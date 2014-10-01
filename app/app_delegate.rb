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
    ['icon', 'audio'].each do |dir_name|
      path = App.documents_path + '/' + dir_name
      filemanager = NSFileManager.defaultManager
      unless filemanager.fileExistsAtPath(path)
        filemanager.createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil, error: nil)

        # copy all audio from Bundle to Document directory
        bundle_icon_path = NSBundle.mainBundle.pathForResource(dir_name, ofType: nil)
        files_in_icon_dir = filemanager.contentsOfDirectoryAtPath(bundle_icon_path, error: nil)
        # then copy the files
        files_in_icon_dir.enumerateObjectsUsingBlock(lambda { |fname, idx, stop|
          srcPath = bundle_icon_path.stringByAppendingPathComponent(fname)
          targetPath = path.stringByAppendingPathComponent(fname)
          filemanager.copyItemAtPath(srcPath, toPath: targetPath, error: nil) 
        })

      end
    end    
  end

end
