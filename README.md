# rakuten : Simple Rakuten API client for Ruby

シンプルな楽天APIクライアント.
Ruby 1.8.7, 1.9.2 で動作確認.

## インストール

    % gem install rakuten

## SYNOPSYS

[楽天WEB SERVICE](http://webservice.rakuten.co.jp/) の各種APIを簡単に使うための gem です.
文字コードには UTF-8 を使用してください.

## サンプル

### 楽天市場系API, 楽天ブックス系API, 楽天オークション系API

以下のようにして、楽天WEB SERVICE APIを呼び出すことができます.

    client = Rakuten::Client.new('DEVELOPER_ID', 'AFFILIATE_ID(オプション)')
    result = client.item_search('2010-09-15', {:keyword => '福袋', :sort => '+itemPrice'})

Rakuten::Client オブジェクトに対して呼び出すメソッド名は、楽天APIの operation パラメーターの名前を小文字にしてアンダースコアでつないだ者です.  
例えば、楽天商品検索API(operation名は"ItemSearch")の呼び出しの場合、メソッド名は "item_search" になります.  
第一引数は、APIのバージョンです. APIのバージョンは、operation 毎に異なりますので注意してください.  
楽天WEB SERVICE API に送信するパラメーター(operationとversionを除く)は、ハッシュにした上で第二引数としてメソッドに渡してください.  
APIのバージョンやパラメーターについては、楽天WEB SERVICEの [ドキュメント](http://webservice.rakuten.co.jp/) を参照してください.

結果は、レスポンスJSONからハッシュの形で取得します. 

    cnt = result['count']
    items = result['Items']['Item']

形式は呼び出したAPIによって様々です. 楽天WEB SERVICEの [ドキュメント](http://webservice.rakuten.co.jp/) の、各APIの解説にある出力パラメーターの欄を参照してください.

エラーが発生した場合は、Rakuten::ApiError が発生します.
Rakuten::ApiError から、エラーの種類とメッセージを取得することができます.

その他のAPIの呼び出し例については、[spec](https://github.com/xanagi/rakuten/blob/master/spec/rakuten_spec.rb) を参照してください.

### 楽天トラベル系API

楽天トラベル系APIは、以下のように Rakuten::TravelClient を使って呼び出します.

    client = Rakuten::TravelClient.new('DEVELOPER_ID', 'AFFILIATE_ID(オプション)')
    result = client.simple_hotel_search('2009-10-20', {:largeClassCode => 'japan', 
                                                       :middleClassCode => 'akita', 
                                                       :smallClassCode => 'tazawa'})
使い方は、Rakuten::Client と同じです.  
その他のAPIの呼び出し例については、[spec](https://github.com/xanagi/rakuten/blob/master/spec/rakuten_travel_spec.rb) を参照してください.

### 楽天ダイナミックアドAPI, 楽天ダイナミックアドAPIトラベル

楽天ダイナミックアドAPI, 楽天ダイナミックアドAPIトラベルを呼び出す場合には、Rakuten::DynamicAdClient を使います.

    # 楽天ダイナミックアドAPI
    client = Rakuten::DynamicAdClient.new('DEVELOPER_ID', 'AFFILIATE_ID(オプション)')
    result = client.dynamic_ad(nil, {:url => 'http://plaza.rakuten.co.jp/isblog/diary/200705230001/'})

    # 楽天ダイナミックアドAPIトラベル
    client = Rakuten::DynamicAdClient.new('DEVELOPER_ID', 'AFFILIATE_ID(オプション)')
    result = client.dynamic_ad_travel(nil, {:url => 'http://plaza.rakuten.co.jp/travelblog02/diary/200706140000/'})


## ライセンス

The MIT License