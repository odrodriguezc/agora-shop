require 'rails_helper'

RSpec.describe Importing::Runner do
  let(:source) { double("source") }
  let(:transform1) { double("transform1") }
  let(:transform2) { double("transform2") }
  let(:destination) { double("destination") }
  let(:runner) do
    described_class.new(
      key: "test_run",
      source: source,
      transforms: [ transform1, transform2 ],
      destination: destination,
      batch_size: 2
    )
  end

  describe "#call" do
    let(:rows) { [ { id: 1 }, { id: 2 }, { id: 3 } ] }

    before do
      allow(source).to receive(:each_batch).with(2).and_yield(rows)
      allow(transform1).to receive(:call) { |row| row } # Return the row directly
      allow(transform2).to receive(:call) { |row| row } # Return the row directly
      allow(destination).to receive(:write)
      allow(destination).to receive(:flush)
      allow(destination).to receive(:close)
      allow(transform1).to receive(:finish)
      allow(transform2).to receive(:finish)
    end

    it "processes rows through transforms and writes to destination" do
      runner.call

      rows.each do |row|
        expect(transform1).to have_received(:call).with(row)
        expect(transform2).to have_received(:call).with(row)
        expect(destination).to have_received(:write).with(row)
      end
    end

    it "calls flush and close on the destination" do
      runner.call

      expect(destination).to have_received(:flush)
      expect(destination).to have_received(:close)
    end

    it "calls finish on transforms" do
      runner.call

      expect(transform2).to have_received(:finish)
      expect(transform1).to have_received(:finish)
    end

    context "when a transform returns nil" do
      before do
        allow(transform1).to receive(:call).and_return(nil)
      end

      it "skips rows that are filtered out by transforms" do
        runner.call

        rows.each do |row|
          expect(transform1).to have_received(:call).with(row)
        end
        expect(transform2).not_to have_received(:call)
        expect(destination).not_to have_received(:write)
      end
    end

    context "when an exception occurs" do
      before do
        allow(source).to receive(:each_batch).and_raise(StandardError, "Test error")
      end

      it "ensures destination flush and close are called" do
        expect { runner.call }.to raise_error(StandardError, "Test error")

        expect(destination).to have_received(:flush)
        expect(destination).to have_received(:close)
      end

      it "ensures transforms finish is called" do
        expect { runner.call }.to raise_error(StandardError, "Test error")

        expect(transform2).to have_received(:finish)
        expect(transform1).to have_received(:finish)
      end
    end
  end
end
