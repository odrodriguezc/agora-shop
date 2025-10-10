
# BackfillSkuAndEnforceProductConstraints
#
# Purpose:
#   - Backfill missing SKU values for existing product records and enforce
#     database-level constraints that ensure every product has a unique, non-null SKU.
#
# What this migration does (high level):
#   1) Uses an inner MigrationProduct model to operate on the products table.
#   2) Refreshes schema cache (reset_column_information) so the model sees the SKU column.
#   3) Finds products with nil or empty SKU and backfills each record in batches
#      (default batch_size: 1_000) by writing a generated SKU directly to the DB.
#   4) Adds a NOT NULL constraint on the sku column.
#   5) Adds a unique index on sku.
#   6) The down direction removes the unique index and allows sku to be null again.
#
# Backfill strategy and behavior:
#   - SKU values are generated deterministically using the product id (e.g. "SKU-00000042").
#   - update_columns is used to set sku values, which bypasses ActiveRecord validations
#     and callbacks and writes directly to the database. This is intentional to avoid
#     application-layer side effects during backfill.
#   - Batching via find_in_batches reduces memory usage and avoids loading the entire
#     table into memory. Batch size can be adjusted depending on available resources.
#
# Safety and operational notes:
#   - Ensure the sku column exists prior to running this migration (this migration assumes
#     the column has been added by an earlier migration).
#   - Adding a unique index will fail if duplicate SKUs already exist. Verify uniqueness
#     (or resolve duplicates) before applying the migration in production.
#   - Adding NOT NULL and UNIQUE constraints on a large table can be expensive. Consider:
#       - Running pre-checks to detect duplicates or nulls.
#       - Using an online/CONCURRENTLY index creation (e.g., add_index(..., algorithm: :concurrently))
#         outside of a transaction if supported by the DB and Rails version, to reduce lock time.
#       - Performing the operation during a maintenance window if necessary.
#   - Because update_columns bypasses callbacks, any application invariants that depend on
#     model callbacks will not run; ensure this is acceptable for the domain.
#
# Rollback and data implications:
#   - The down method removes the unique index and makes sku nullable again but does not
#     revert the backfilled SKU values. Reverting to previous state (removing generated SKUs)
#     would require a separate migration or a DB restore.
#   - Consider taking a backup or ensuring a reversible remediation plan before running.
#
# Testing and verification:
#   - Test the migration against a recent production snapshot in staging to confirm:
#       - No duplicate SKUs exist or are created by the backfill logic.
#       - Performance characteristics and locking behavior are acceptable.
#       - Any dependent application code handles the new NOT NULL/unique constraints.
#   - Verify index name and potential collisions with existing indexes.
#
# Notes for maintainers:
#   - Keep this migration idempotent and safe to re-run in environments that may have
#     partially applied changes (carefully handle the presence/absence of the index and constraint).
#   - Document any follow-up steps (e.g., enabling concurrent index creation) and the
#     rationale for SKU format so future maintainers understand the generated value pattern.
#
# Security and privacy:
#   - Generated SKUs are deterministic and derived from internal ids; ensure this exposure
#     is acceptable for your product naming/privacy policies.
#
# Authoring detail:
#   - Uses a simple "SKU-<zero-padded id>" format for readability and uniqueness.
class BackfillSkuAndEnforceProductConstraints < ActiveRecord::Migration[8.0]
  class MigrationProduct < ActiveRecord::Base
    self.table_name = "products"
  end

  def up
    MigrationProduct.reset_column_information # Ensure the model knows about the new column (refresh schema cache)

    say_with_time("Backfilling SKU for existing products") do
      MigrationProduct.where(sku: [ nil, "" ]).find_in_batches(batch_size: 1_000) do |batch|
        batch.each do |product|
          product.update_columns(sku: generated_sku(product))
        end
      end
    end

    change_column_null :products, :sku, false
    add_index :products, :sku, unique: true
  end

  def down
    remove_index :products, :sku
    change_column_null :products, :sku, true
  end

  private

  def generated_sku(product)
    "SKU-#{product.id.to_s.rjust(8, '0')}"
  end
end
