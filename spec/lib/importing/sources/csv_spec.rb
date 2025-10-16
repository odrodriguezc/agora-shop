require 'rails_helper'
require "tempfile"
require "csv"

RSpec.describe Importing::Sources::CSV do
  def write_csv(content)
    f = Tempfile.new([ "importing_sources_csv", ".csv" ])
    f.binmode
    f.write(content)
    f.flush
    f
  end

  context "when no block given" do
    it "returns an enumerator when no block is given" do
      file = write_csv("id,name\n1,Alice\n")
      source = Importing::Sources::CSV.new(path: file.path)

      enum = source.each
      expect(enum).to be_an(Enumerator)

      first_row = enum.take(1).first
      expect(first_row).to eq({ "id" => "1", "name" => "Alice" })
    ensure
      file.close
      file.unlink
    end
  end

  context "when a block is given" do
    it "yields each row to the block" do
      file = write_csv("id,name\n1,Alice\n2,Bob\n")
      source = Importing::Sources::CSV.new(path: file.path)
      rows = []
      source.each { |r| rows << r }

      expect(rows).to eq([
        { "id" => "1", "name" => "Alice" },
        { "id" => "2", "name" => "Bob" }
      ])
    ensure
      file.close
      file.unlink
    end
  end

  describe "#each_batch" do
    it "returns an enumerator when no block is given" do
      file = write_csv("id,name\n1,Alice\n")
      source = described_class.new(path: file.path)

      enum = source.each_batch(2)
      expect(enum).to be_an(Enumerator)
      expect(enum.take(1).first).to eq([ { "id" => "1", "name" => "Alice" } ])
    ensure
      file.close
      file.unlink
    end

    it "yields batches of the requested size" do
      file = write_csv("id,name\n1,Alice\n2,Bob\n3,Carol\n")
      source = described_class.new(path: file.path)
      batches = []

      source.each_batch(2) { |batch| batches << batch }

      expect(batches).to eq([
        [
          { "id" => "1", "name" => "Alice" },
          { "id" => "2", "name" => "Bob" }
        ],
        [
          { "id" => "3", "name" => "Carol" }
        ]
      ])
    ensure
      file.close
      file.unlink
    end
  end
end
