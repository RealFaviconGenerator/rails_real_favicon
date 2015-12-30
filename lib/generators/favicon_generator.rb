require 'rest-client'
require 'json'
require 'open-uri'
require 'zip'
require 'base64'

class FaviconGenerator < Rails::Generators::Base
  API_KEY = '04641dc33598f5463c2f1ff49dd9e4a617559f4b'

  PATH_UNIQUE_KEY = 'Dfv87ZbNh2'

  def generate_favicon
    req = JSON.parse File.read('config/favicon.json')

    req['api_key'] = API_KEY

    req['files_location'] = Hash.new
    req['files_location']['type'] = 'path'
    req['files_location']['path'] = PATH_UNIQUE_KEY

    master_pic = File.expand_path(".") + '/' + req['master_picture']
    req['master_picture'] = Hash.new
    req['master_picture']['type'] = 'inline'
    req['master_picture']['content'] = Base64.encode64(File.read(master_pic))

    response = RestClient.post("https://realfavicongenerator.net/api/favicon",
      {favicon_generation: req}.to_json, content_type: :json)
    resp = JSON.parse(response)

    zip = resp['favicon_generation_result']['favicon']['package_url']
    FileUtils.mkdir_p('app/assets/images/favicon')

    Dir.mktmpdir 'rfg' do |tmp_dir|
      download_package zip, tmp_dir
      Dir["#{tmp_dir}/*.*"].each do |file|
        content = File.read(file)
        new_ext = ''
        if File.extname(file) == '.json' or File.extname(file) == '.xml'
          content = replace_url_by_asset_path content
          new_ext = '.erb'
        end
        create_file "app/assets/images/favicon/#{File.basename file}#{new_ext}", content
      end
    end

    create_file "app/views/application/_favicon.html.erb",
      replace_url_by_asset_path(resp['favicon_generation_result']['favicon']['html_code'])
  end

  private

  def download_package(package_url, output_dir)
    file = Tempfile.new('fav_package')
    file.close
    download_file package_url, file.path
    extract_zip file.path(), output_dir
  end

  def download_file(url, local_path)
    if File.directory?(local_path)
      uri = URI.parse(url)
      local_path += '/' + File.basename(uri.path)
    end

    File.open(local_path, "wb") do |saved_file|
      open(url, "rb") do |read_file|
        saved_file.write(read_file.read)
      end
    end
  end

  def extract_zip(zip_path, output_dir)
    Zip::File.open zip_path do |zip_file|
      zip_file.each do |f|
        f_path=File.join  output_dir, f.name
        FileUtils.mkdir_p  File.dirname(f_path)
        zip_file.extract(f, f_path) unless File.exist? f_path
      end
    end
  end

  def replace_url_by_asset_path(content)
    repl = "\"<%= asset_path 'favicon\\k<path>' %>\""
    content.gsub /"#{PATH_UNIQUE_KEY}(?<path>[^"]+)"/ do |s|
      s.gsub! /\\\//, '/'
      s.gsub /"#{PATH_UNIQUE_KEY}(?<path>[^"]+)"/, repl
    end
  end

end
