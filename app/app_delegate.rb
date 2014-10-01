class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    startup
  	@window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.applicationFrame)
  	@window.rootViewController = MainViewController.new
  	@window.makeKeyAndVisible
    true
  end

  # check icon und audio directory
  def startup
    ['/icon', '/audio'].each do |dir_name|
      path = App::documents_path + dir_name
      filemanager = NSFileManager.defaultManager
      unless filemanager.fileExistsAtPath(path)
        filemanager.createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil, error: nil)
      end
    end    
  end

end
