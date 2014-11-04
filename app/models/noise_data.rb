class NoiseData 

  def initialize
    @noise_list = App::Persistence['saved_noise_list'] || []
    @audioPlayer = nil

    @original_noises = [{id: 1, sounds: ['laugh1.mp3'], icon: 'laugh.png'}, 
      {id: 2, sounds: ['fart1.mp3'], icon: 'fart.png'}, {id: 3, sounds: ['barf1.mp3'], icon: 'puke.png'},
      {id: 4, sounds: ['scream9.mp3'], icon: 'ambient.png'}]
    @original_noises.each {|on| @noise_list << on}  
  end

  def noise_list=(new_list)
    @noise_list = new_list
    @original_noises.each { |on| @noise_list << on}
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
        cell.contentView.addSubview(imageview)
      end

      noise_definition = @noise_list[indexPath.row]
      icon_name = noise_definition[:icon]

      if iconExist?(icon_name)
        imageview.image = UIImage.imageWithContentsOfFile(App.documents_path + '/icon/' + icon_name)
      else
        # imageview.url = {url: SERVER_ADDR + 'assets/'+ icon_name, placeholder:  UIImage.imageNamed('default_icon.png')}
        # asynchron download and save
        AFMotion::Image.get(SERVER_ADDR + 'assets/'+ icon_name) do |img|
          icon_image = img.object
          imageview.image = icon_image
          imageData = UIImagePNGRepresentation(icon_image)
          if imageData.nil?
          else
            imageData.writeToFile(App.documents_path+'/icon/'+icon_name, atomically: true)
          end
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
    sound_names = @noise_list[indexPath.row][:sounds]
    sound_name = nil
    sound_name = sound_names[Random.rand(sound_names.length)]
    # play sound
    # 1. file in Bundle?

    # 2. download sound from server
    taped_cell = collectionView.cellForItemAtIndexPath(indexPath)
    if soundExist?(sound_name)
      playSound(sound_name, forCell: taped_cell)
    else
      urlStr = SERVER_ADDR + 'audio/' + sound_name
      request = NSURLRequest.requestWithURL(NSURL.URLWithString(urlStr))

      downloadOperation = AFHTTPRequestOperation.alloc.initWithRequest(request)
      downloadOperation.outputStream = NSOutputStream.outputStreamToFileAtPath(App.documents_path + '/audio/'+sound_name, append: false)
      # error_ptr = Pointer.new(:object)
      downloadOperation.setCompletionBlockWithSuccess(lambda { |operation, responseObject| 
        playSound(sound_name, forCell: taped_cell)
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

  def playSound(name, forCell: cell)

    if @audioPlayer != nil && @audioPlayer.isPlaying
      @audioPlayer.stop
      @progressTimer.invalidate
      @progressTimer = nil
      progressView = @cell_for_progress.viewWithTag(102)
      progressView.removeFromSuperview
    end

    file_path = App.documents_path + '/audio/' + name
    error_ptr = Pointer.new(:object)
    @audioPlayer = AVAudioPlayer.alloc.initWithContentsOfURL(NSURL.fileURLWithPath(file_path), error: error_ptr)
    if @audioPlayer != nil
      @audioPlayer.delegate = self
      @audioPlayer.prepareToPlay
      @audioPlayer.play

      progressView = PDColoredProgressView.alloc.initWithProgressViewStyle(UIProgressViewStyleDefault)
      cell_frame = cell.frame
      progress_frame = CGRectMake(1, cell_frame.size.height - 10, cell_frame.size.width - 2, 5)
      progressView.frame = progress_frame
      progressView.setTintColor(UIColor.greenColor())
      progressView.tag = 102
      cell.contentView.addSubview(progressView)

      @progressTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: 'updateTimeLeft', userInfo: nil, repeats: true)
      @cell_for_progress = cell

    else
      # p "file: #{name} can not played";
    end
  end

  def audioPlayerDidFinishPlaying(player, successfully: flag)
    @audioPlayer = nil

    progressView = @cell_for_progress.viewWithTag(102)
    progressView.removeFromSuperview
    progressView = nil
    @progressTimer.invalidate
    @progressTimer = nil
  end

  def updateTimeLeft
    percent = @audioPlayer.currentTime / @audioPlayer.duration

    progressView = @cell_for_progress.viewWithTag(102)
    progressView.progress = percent
  end


end




