class MediaAPI < Grape::API
  resource 'medias' do
    get "/" do        
      found_successfully Media.all
    end
  end
end