# spec/views/layouts/_flash_html_erb_spec.rb
require 'rails_helper'
RSpec.describe "layouts/_flash.html.erb", type: :view do
  def render_partial
    render partial: "layouts/flash"
  end

  context "when flash is empty" do
    it "renders nothing" do
      flash.clear
      render_partial
      expect(rendered.strip).to eq("")
    end
  end

  context "single messages" do
    it "renders notice with blue background (expected behavior)" do
      flash.clear
      flash[:notice] = "Success message"
      render_partial
      expect(rendered).to include("Success message")
    end

    it "renders alert with red background" do
      flash.clear
      flash[:alert] = "Error message"
      render_partial
      expect(rendered).to include("Error message")
    end

    it "renders custom key (warning) with red background fallback" do
      flash.clear
      flash[:warning] = "Warning message"
      render_partial
      expect(rendered).to include("Warning message")
    end
  end

  context "multiple messages" do
    it "renders both messages" do
      flash.clear
      flash[:notice] = "Notice A"
      flash[:alert]  = "Alert B"
      render_partial
      expect(rendered).to include("Notice A")
      expect(rendered).to include("Alert B")
      expect(rendered.scan(/class="/).size).to be >= 2
    end

    it "preserves insertion order" do
      flash.clear
      flash[:first]  = "First"
      flash[:second] = "Second"
      render_partial
      first_index  = rendered.index("First")
      second_index = rendered.index("Second")
      expect(first_index).to be < second_index
    end
  end

  context "content safety" do
    it "escapes HTML in message" do
      flash.clear
      flash[:alert] = "<script>alert('x')</script>"
      render_partial
      expect(rendered).to include("&lt;script&gt;alert(&#39;x&#39;)&lt;/script&gt;")
      expect(rendered).not_to include("<script>alert('x')</script>")
    end

    it "renders numeric and symbol-convertible messages" do
      flash.clear
      flash[:notice] = 12345
      render_partial
      expect(rendered).to include("12345")
    end
  end

  context "structure" do
    it "wraps messages in fixed container when present" do
      flash.clear
      flash[:alert] = "X"
      render_partial
      expect(rendered).to match(/<div class="fixed .*?">/m)
    end

    it "adds a dismiss link per message" do
      flash.clear
      flash[:alert] = "Dismiss me"
      render_partial
      expect(rendered).to include("&times;")
      expect(rendered).to include("onclick=\"this.parentElement.remove(); return false;\"")
    end
  end

  context "edge cases" do
    it "handles nil message gracefully" do
      flash.clear
      flash[:alert] = nil
      render_partial
      expect(rendered).to include("<span></span>")
    end

    it "does not raise with many messages" do
      flash.clear
      10.times { |i| flash["k#{i}".to_sym] = "M#{i}" }
      expect { render_partial }.not_to raise_error
      10.times { |i| expect(rendered).to include("M#{i}") }
    end
  end
end
# TODO: Add test to control the styles applied based on flash type
