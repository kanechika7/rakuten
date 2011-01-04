rakuten : Simple Rakuten API client for Ruby
============================================

シンプルな楽天APIクライアント.
Ruby 1.9.2 で動作確認.

サンプル
-------

* 楽天商品検索API

    client = Rakuten::Client.new('DEVELOPER_ID', 'AFFILIATE_ID(オプション)')
    result = @client.item_search('2010-09-15', {:keyword => '福袋', :sort => '+itemPrice'})
    cnt = result['count']
    items = result['Items']['Item']

* 楽天ジャンル検索API

    result = client.genre_search('2007-04-11', {:genreId => 0}) # ルートレベル
    genre_level = result['child'][0]['genreLevel']
    genre_name = result['child'][0]['genreName']
    genre_id = result['child'][0]['genreId']

    result = client.genre_search('2007-04-11', {:genreId => 100227}) # 食品ジャンル

* 楽天商品コード検索API

    result = @client.item_code_search('2010-08-05', {:itemCode => item_code})
    items = result['Items']['Item']

* 楽天カタログ検索API

    result = client.catalog_search('2009-04-15', {:keyword => '液晶テレビ', :sort => '-reviewCount'})
    cnt = result['count']
    catalogs = result['Catalogs']['Catalog']

* 楽天商品ランキングAPI

    result = client.item_ranking('2010-08-05')
    title = result['title'].should_not be_nil
    last_build_date = result['lastBuildDate'].should_not be_nil
    items = result['Items']['Item']
  
* 楽天プロダクト製品検索API

    result = client.product_search('2010-11-18', {:keyword => 'ノートパソコン', :genreId => 100040})
    items = result['Items']['Item']

* 楽天プロダクト製品詳細API

    result = client.product_detail('2010-11-18', {:productId => product_id, :detailFlag => 1})
    item = result['Item']

* 楽天プロダクトジャンル情報API
    result = client.product_genre_info('2010-11-18', {:genreId => 500740, :makerHits => 10, :satisfiedHits => 5, :satisfiedPage => 3})
    satisfiers = result['SatisfiedInformation']['satisfier']
    genre_information = result['GenreInformation']
    maker_information = result['MakerInformation']['maker']
  end

* 楽天プロダクトメーカー情報API

    result = client.product_maker_info('2010-11-18', {:makerCode => 104901780})
    maker_name = result['makerName']

* 楽天プロダクト価格比較情報API

    result = client.product_price_info('2010-11-18', {:productId => product_id, :availability => 1, :creditCardFlag => 1})
    cnt = result['count']
    items = result['Items']['Item']
