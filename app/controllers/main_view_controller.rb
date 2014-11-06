class MainViewController < UIViewController

  def loadView
    super

    @datas = NoiseData.new

    self.view.backgroundColor = UIColor.whiteColor()
    # CollectionView layout - flowLayout
    flowLayout = UICollectionViewFlowLayout.alloc.init
    #flowLayout.setItemSize(CGSizeMake(40, 40))

    @collectionView = UICollectionView.alloc.initWithFrame(CGRectZero, collectionViewLayout: flowLayout)
    @collectionView.backgroundColor = UIColor.whiteColor()
    @collectionView.registerClass(UICollectionViewCell, forCellWithReuseIdentifier: 'CELL')
    @collectionView.dataSource = @datas
    @collectionView.delegate = @datas

    @refreshControl = UIRefreshControl.new
    @refreshControl.addTarget(self, action: 'shouldRefresh', forControlEvents: UIControlEventValueChanged)
    @collectionView.addSubview(@refreshControl)
    @collectionView.alwaysBounceVertical = true

    @bannerView = ADBannerView.alloc.init()
    # @bannerView.delegate = self

    Motion::Layout.new do |layout|
      layout.view(view)
      layout.subviews(collection: @collectionView, banner: @bannerView)
      layout.vertical('|-5-[collection]-[banner(==66)]-5-|')
      layout.horizontal('|-5-[collection]-5-|')
      layout.horizontal('|-5-[banner]-5-|')
    end

  end

  def shouldRefresh
    # make get request to server
    AFMotion::JSON.get(SERVER_ADDR + 'noises/all') do |result|
      @refreshControl.endRefreshing

      if result.success?
        noises = result.object
        save_noise(noises)
      elsif result.failure?
        # p result.error.localizedDescription
      end
    end
  end

  private

  def save_noise(noises)
    App::Persistence['saved_noise_list'] = noises
    @datas.noise_list= noises
    @collectionView.reloadData
  end

end