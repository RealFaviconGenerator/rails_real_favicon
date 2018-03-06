require 'test_helper'
require 'generators/favicon_generator'

class FaviconGeneratorTest < Rails::Generators::TestCase
  tests FaviconGenerator
  destination Rails.root.join('tmp/generators')
  setup :prepare_destination

  test "replace URLs by asset_path in XML" do
    original = <<EOF
<?xml version="1.0" encoding="utf-8"?>
<browserconfig>
  <msapplication>
    <tile>
      <square70x70logo src="/Dfv87ZbNh2/mstile-70x70.png"/>
      <square150x150logo src="/Dfv87ZbNh2/mstile-150x150.png"/>
      <square310x310logo src="/Dfv87ZbNh2/mstile-310x310.png"/>
      <wide310x150logo src="/Dfv87ZbNh2/mstile-310x150.png"/>
      <TileColor>#da532c</TileColor>
    </tile>
  </msapplication>
</browserconfig>
EOF

    expected = <<EOF
<?xml version="1.0" encoding="utf-8"?>
<browserconfig>
  <msapplication>
    <tile>
      <square70x70logo src="<%= asset_path 'favicon/mstile-70x70.png' %>"/>
      <square150x150logo src="<%= asset_path 'favicon/mstile-150x150.png' %>"/>
      <square310x310logo src="<%= asset_path 'favicon/mstile-310x310.png' %>"/>
      <wide310x150logo src="<%= asset_path 'favicon/mstile-310x150.png' %>"/>
      <TileColor>#da532c</TileColor>
    </tile>
  </msapplication>
</browserconfig>
EOF
    gen = FaviconGenerator.new
    assert_equal expected, gen.send(:replace_url_by_asset_path, original)
  end

  test "replace URLs by asset_path in JSON" do
    original = <<EOF
{
	"name": "The app",
	"icons": [
		{
			"src": "/Dfv87ZbNh2\\/android-chrome-36x36.png",
			"sizes": "36x36",
			"type": "image\\/png",
			"density": "0.75"
		},
		{
			"src": "/Dfv87ZbNh2\\/android-chrome-48x48.png",
			"sizes": "48x48",
			"type": "image\\/png",
			"density": "1.0"
		}
	]
}
EOF

    expected = <<EOF
{
	"name": "The app",
	"icons": [
		{
			"src": "<%= asset_path 'favicon/android-chrome-36x36.png' %>",
			"sizes": "36x36",
			"type": "image\\/png",
			"density": "0.75"
		},
		{
			"src": "<%= asset_path 'favicon/android-chrome-48x48.png' %>",
			"sizes": "48x48",
			"type": "image\\/png",
			"density": "1.0"
		}
	]
}
EOF
    gen = FaviconGenerator.new
    assert_equal expected, gen.send(:replace_url_by_asset_path, original)
  end

  test "replace URLs by asset_path in HTML" do
    original = <<EOF
<link rel="apple-touch-icon" sizes="180x180" href="/Dfv87ZbNh2/apple-touch-icon-180x180.png">
<link rel="icon" type="image/png" href="/Dfv87ZbNh2/favicon-16x16.png" sizes="16x16">
<link rel="manifest" href="/Dfv87ZbNh2/manifest.json">
<link rel="shortcut icon" href="/Dfv87ZbNh2/favicon.ico">
<meta name="msapplication-TileColor" content="#da532c">
<meta name="msapplication-TileImage" content="/Dfv87ZbNh2/mstile-144x144.png">
<meta name="msapplication-config" content="/Dfv87ZbNh2/browserconfig.xml">
<meta name="theme-color" content="#ffffff">
EOF

    expected = <<EOF
<link rel="apple-touch-icon" sizes="180x180" href="<%= asset_path 'favicon/apple-touch-icon-180x180.png' %>">
<link rel="icon" type="image/png" href="<%= asset_path 'favicon/favicon-16x16.png' %>" sizes="16x16">
<link rel="manifest" href="<%= asset_path 'favicon/manifest.json' %>">
<link rel="shortcut icon" href="<%= asset_path 'favicon/favicon.ico' %>">
<meta name="msapplication-TileColor" content="#da532c">
<meta name="msapplication-TileImage" content="<%= asset_path 'favicon/mstile-144x144.png' %>">
<meta name="msapplication-config" content="<%= asset_path 'favicon/browserconfig.xml' %>">
<meta name="theme-color" content="#ffffff">
EOF
    gen = FaviconGenerator.new
    assert_equal expected, gen.send(:replace_url_by_asset_path, original)
  end
end
