class NoiseData 

	def collectionView(collectionView, numberOfItemsInSection: section)
		40
	end

	def collectionView(collectionView, cellForItemAtIndexPath: indexPath)
		collectionView.dequeueReusableCellWithReuseIdentifier('CELL', forIndexPath: indexPath).tap do |cell|
			cell.backgroundColor = UIColor.yellowColor()
		end
	end

	def collectionView(collectionView, layout: collectionViewLayout, sizeForItemAtIndexPath: indexPath)
    return CGSizeMake(70, 70)
  end

  def collectionView(collectionView, layout: collectionViewLayout, insetForSectionAtIndex: section)
    return UIEdgeInsetsMake(5, 5, 5, 5)
  end
end