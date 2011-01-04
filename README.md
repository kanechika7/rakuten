rakuten : Simple Rakuten API client for Ruby
============================================

シンプルな楽天APIクライアント.
Ruby 1.9.2 で動作確認.

楽天市場系API呼び出しサンプル
-------

楽天商品検索API

    client = Rakuten::Client.new('DEVELOPER_ID', 'AFFILIATE_ID(オプション)')
    result = @client.item_search('2010-09-15', {:keyword => '福袋', :sort => '+itemPrice'})
    cnt = result['count']
    items = result['Items']['Item']

楽天ジャンル検索API

    result = client.genre_search('2007-04-11', {:genreId => 0}) # ルートレベル
    genre_level = result['child'][0]['genreLevel']
    genre_name = result['child'][0]['genreName']
    genre_id = result['child'][0]['genreId']

    result = client.genre_search('2007-04-11', {:genreId => 100227}) # 食品ジャンル

楽天商品コード検索API

    result = @client.item_code_search('2010-08-05', {:itemCode => item_code})
    items = result['Items']['Item']

楽天カタログ検索API

    result = client.catalog_search('2009-04-15', {:keyword => '液晶テレビ', :sort => '-reviewCount'})
    cnt = result['count']
    catalogs = result['Catalogs']['Catalog']

楽天商品ランキングAPI

    result = client.item_ranking('2010-08-05')
    title = result['title']
    last_build_date = result['lastBuildDate']
    items = result['Items']['Item']
  
楽天プロダクト製品検索API

    result = client.product_search('2010-11-18', {:keyword => 'ノートパソコン', :genreId => 100040})
    items = result['Items']['Item']

楽天プロダクト製品詳細API

    result = client.product_detail('2010-11-18', {:productId => product_id, :detailFlag => 1})
    item = result['Item']

楽天プロダクトジャンル情報API

    result = client.product_genre_info('2010-11-18', {:genreId => 500740, :makerHits => 10, :satisfiedHits => 5, :satisfiedPage => 3})
    satisfiers = result['SatisfiedInformation']['satisfier']
    genre_information = result['GenreInformation']
    maker_information = result['MakerInformation']['maker']

楽天プロダクトメーカー情報API

    result = client.product_maker_info('2010-11-18', {:makerCode => 104901780})
    maker_name = result['makerName']

楽天プロダクト価格比較情報API

    result = client.product_price_info('2010-11-18', {:productId => product_id, :availability => 1, :creditCardFlag => 1})
    cnt = result['count']
    items = result['Items']['Item']


楽天ブックス系API呼び出しサンプル
------

楽天ブックス総合検索API

    client = Rakuten::Client.new('DEVELOPER_ID', 'AFFILIATE_ID(オプション)')
    result = client.books_total_search('2010-03-18', {:keyword => 'ガンダム', :NGKeyword => '予約', :sort => '+itemPrice'})
    cnt = result['count']
    items = result['Items']['Item']

楽天ブックス書籍検索API

    result = client.books_book_search('2010-03-18', {:title => '太陽', :booksGenreId => '001004008', :sort => '+itemPrice'})
    cnt = result['count']
    items = result['Items']['Item']

楽天ブックスCD検索API

    result = client.books_CD_search('2010-03-18', {:artistName => 'サザンオールスターズ', :sort => '+itemPrice'})
    cnt = result['count'] > 0
    items = result['Items']['Item']

楽天ブックスDVD検索API

    result = @client.books_DVD_search('2010-03-18', {:title => 'ガンダム', :sort => '+itemPrice'})
    cnt = result['count']
    items = result['Items']['Item']

楽天ブックス洋書検索API

    result = client.books_foreign_book_search('2010-03-18', {:title => 'HarryPotter', :booksGenreId => '005407', :sort => '+itemPrice'})
    cnt = result['count']
    items = result['Items']['Item']

楽天ブックス雑誌検索API

    result = client.books_magazine_search('2010-03-18', {:title => '週刊 経済', :booksGenreId => '007604001', :sort => '+itemPrice'})
    cnt = result['count']
    items = result['Items']['Item']

楽天ブックスゲーム検索API

    result = client.books_game_search('2010-03-18', {:title => 'マリオ', :hardware => 'Wii', :sort => '+itemPrice'})
    cnt = result['count']
    items = result['Items']['Item']

楽天ブックスソフトウェア検索API

    result = client.books_software_search('2010-03-18', {:title => '会計', :os => 'Mac', :sort => '+itemPrice'})
    cnt = result['count']
    items = result['Items']['Item']

楽天ブックスジャンル検索API

    result = client.books_genre_search('2009-03-26', {:booksGenreId => '000'})
    genre_level = result['child'][0]['genreLevel']
    genre_name = result['child'][0]['genreName']
    genre_id = result['child'][0]['genreId']

