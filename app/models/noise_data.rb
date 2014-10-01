class NoiseData 

  attr_accessor :noise_list
  # SERVER_ADDR = 'http://192.168.196.186:3000/'
  SERVER_ADDR = 'http://192.168.178.46:3000/'

  def initialize
    @noise_list = []
    @audioPlayer = nil

    @original_noises = [{id: 1, name: 'barf1.mp3', icon: 'laugh.png'}, 
      {id: 2, name: 'fart1.mp3', icon: 'fart.png'}, {id: 3, name: 'barf1.mp3', icon: 'ambient.png'},
      {id: 4, name: 'scream9.mp3', icon: 'puke.png'}]
    @original_noises.each {|on| @noise_list << on}  
  end

	def collectionView(collectionView, numberOfItemsInSection: section)
    @noise_list.size
	end

	def collectionView(collectionView, cellForItemAtIndexPath: indexPath)
		collectionView.dequeueReusableCellWithReuseIdentifier('CELL', forIndexPath: indexPath).tap do |cell|
			# cell.backgroundColor = UIColor.yellowColor()
      # ueberprueft, ob das icon fuer diese Cell vorhanden ist. ja: anzeigen, nein: asynchron loaden.
      cell.layer.cornerRadius = 6
      cell.layer.borderWidth = 2
      cell.layer.borderColor = UIColor.blueColor().CGColor()

      imageview = cell.contentView.viewWithTag(100)
      if imageview.nil?
        imageview = UIImageView.alloc.initWithFrame(CGRectMake(0,0,70,70))
        imageview.tag = 100
        imageview.image = UIImage.imageNamed('default_icon.png')
        cell.contentView.addSubview(imageview)
      end

      noise_definition = @noise_list[indexPath.row]
      p noise_definition[:icon]
      icon_name = noise_definition[:icon]

      if iconExist?(icon_name)
        imageview.image = UIImage.imageWithContentsOfFile(App.documents_path + '/icon/' + icon_name)
      else
        # asynchron download and save
        AFMotion::Image.get(SERVER_ADDR + 'assets/'+ icon_name) do |img|
          icon_image = img.object
          imageview.image = icon_image
        end
      end
		end
	end

	def collectionView(collectionView, layout: collectionViewLayout, sizeForItemAtIndexPath: indexPath)
    return CGSizeMake(70, 70)
  end

  def collectionView(collectionView, layout: collectionViewLayout, insetForSectionAtIndex: section)
    return UIEdgeInsetsMake(5, 5, 5, 5)
  end

  # UICollectionView Delegate 
  def collectionView(collectionView, didSelectItemAtIndexPath: indexPath)
    sound_name = @noise_list[indexPath.row][:name]
    # play sound
    # 1. file in Bundle?

    # 2. download sound from server
    if soundExist?(sound_name)
      playSound(sound_name)
    else
      urlStr = SERVER_ADDR + 'audio/' + sound_name
      request = NSURLRequest.requestWithURL(NSURL.URLWithString(urlStr))

      downloadOperation = AFHTTPRequestOperation.alloc.initWithRequest(request)
      downloadOperation.outputStream = NSOutputStream.outputStreamToFileAtPath(App.documents_path + '/audio/'+sound_name, append: false)
      # error_ptr = Pointer.new(:object)
      downloadOperation.setCompletionBlockWithSuccess(lambda { |operation, responseObject| 
        playSound(sound_name)
       }, failure: lambda { |operation, error_ptr| 
        } )
      downloadOperation.start  
    end
  end

  private 

  def iconExist?(filename)
    file_path = App.documents_path + '/icon/' + filename

    NSFileManager.defaultManager.fileExistsAtPath(file_path)
  end

  def soundExist?(filename)
    file_path = App.documents_path + '/audio/' + filename
    NSFileManager.defaultManager.fileExistsAtPath(file_path)
  end

  def playSound(name)
    file_path = App.documents_path + '/audio/' + name
    error_ptr = Pointer.new(:object)
    @audioPlayer = AVAudioPlayer.alloc.initWithContentsOfURL(NSURL.fileURLWithPath(file_path), error: error_ptr)
    @audioPlayer.delegate = self
    @audioPlayer.prepareToPlay
    @audioPlayer.play

  end

  def audioPlayerDidFinishPlaying(player, successfully: flag)
    @audioPlayer = nil

  end
end




