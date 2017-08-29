class Director
  WALL_WIDTH = 20
  UNDER_WALL_WIDTH = 40
  BOX_SIZE = 30

  def initialize

    #ワールド座標系の生成
    @rt = RenderTarget.new(8200, 10000)

    #背景の変数を定義
    @bg_image_haikei=Image.load("images/haikei.png")
    @bg_image_sora=Image.load("images/sora.png")
    @bg_image_tuta=Image.load('images/waku.png')
    @bg_image_tuta.set_color_key(C_WHITE)
    @bg_image_kabe=Image.load('images/kabe.png')
    @bg_image_kabe.set_color_key(C_WHITE)

    @space = CP::Space.new
    @space.gravity = CP::Vec2.new(0, 500)
    @speed = 1 / 60.0
    @objects = {}

    # 壁の生成と登録
    [
     [WALL_WIDTH, Window.height - WALL_WIDTH,4000, UNDER_WALL_WIDTH],         # 1床
     [4000 + WALL_WIDTH, Window.height - WALL_WIDTH, 4000, UNDER_WALL_WIDTH], # 1床
     [WALL_WIDTH, 2*Window.height - WALL_WIDTH, 4000, UNDER_WALL_WIDTH],       # 2床
     [4000+ WALL_WIDTH, 2*Window.height - WALL_WIDTH, 3800, UNDER_WALL_WIDTH], # 2床
     [WALL_WIDTH, 3*Window.height - WALL_WIDTH,4000, UNDER_WALL_WIDTH],        # 3床
     [3700 + WALL_WIDTH, 3*Window.height - WALL_WIDTH,4000, UNDER_WALL_WIDTH], # 3床
     [3800,2*Window.height + WALL_WIDTH, 40, 100],    #4000地点壁
     [3600,2*Window.height + 200, 40, 200],           #4000地点壁
     [3800,3*Window.height - WALL_WIDTH-100, 40, 100],#4000地点壁
     [0, 0, WALL_WIDTH, 1800],               # 左壁
     [8000 + WALL_WIDTH, 1050, WALL_WIDTH,300], # 右壁
    ].each do |x, y, w, h|
      add_obj(Wall.new(x, y, w, h))
    end

    # ボールの生成
    @ball = Ball.new(60, 1750, 25)
    add_obj(@ball)

    #ダルマ生成
    @daruma = []		# ダルマをいれる配列
    #ダルマの画像を入れる配列
    daruma_img = ['images/daruma1.png','images/daruma2.png','images/daruma3.png','images/daruma4.png','images/daruma_atama.png']
    #五回繰り返して五個のダルマを生成
    5.times do |i|
      num = i + 1
      @daruma << (Daruma.new(600 + rand(30), 2*Window.height-WALL_WIDTH - num * 90, 120, 90,image: daruma_img[i]))
      add_obj(@daruma[i])
    end

    #たる壁の生成
    @taru = []
     5.times do |t|
     num = t + 1
     @taru << (Box.new(6500, 3*Window.height-WALL_WIDTH - num * 100, 100, 90, mass: 2,image: 'images/taru.png'))
     add_obj(@taru[t])
     end

    #イライラ棒の生成
    @ira_ary = []
      3.times do |r|
      num = r + 1
      @ira_ary << [500 + num *600 , 2*Window.height+WALL_WIDTH, 50, 200]
      end
      @ira_ary.each do |x, y, w, h|
      add_obj(Ira.new(x, y, w, h))
    end

    @ira_ary2 = []
      2.times do |n|
      num = n + 1
      @ira_ary2 << [500 + num *1000 , 3*Window.height-WALL_WIDTH-100, 50, 100]
      end
      @ira_ary2.each do |x, y, w, h|
      add_obj(Ira.new(x, y, w, h))
    end

    #網の生成
    @net = Net.new(7000, WALL_WIDTH+200, 200,200,image: 'images/ami.png' )
    @net.ball = @ball
    add_obj(@net)

    #ワープトラップの生成
    @goal = Warp.new(WALL_WIDTH + 2000, 2*Window.height - WALL_WIDTH - 300, 120, 300, image: 'images/goal.png' )
    add_obj(@goal)

    #いもむしの生成
    @warm = []
    warm_image = ['images/warm1.png','images/warm2.png','images/warm3.png','images/warm4.png', 'images/warm5.png']
    5.times do|i|
        @warm << Warm.new(4000  + rand(1000)-500 , 2*Window.height - WALL_WIDTH-150 ,180,150, image: warm_image[i] )
        @warm[i].ball = @ball
        add_obj(@warm[i])
    end

    #跳ねる箱の生成
    [
     [4001, 1460, 60, 60, 'images/kumo1.png'],
     [4400, 1500, 50, 50, 'images/kumo2.png'],
     [4650, 1760, 150, 30 ,'images/kumo3.png'],
     [4700, 1300, 100, 20, 'images/kumo4.png'],
     [5363, 1760, 100, 20, 'images/kumo5.png'],
     [5550, 1300, 50 , 80, 'images/kumo6.png'],
     [5785, 1550, 100, 100, 'images/kumo7.png'],
    ].each do |x, y, w, h, image_name|
      add_obj(Bane.new(x, y, w, h,  image:image_name))
    end
    #跳ねる箱ダミー
    [
     [4860, 1600, 250, 20,'images/kumo8.png'],
     [5163, 1400, 100, 50,'images/kumo9.png'],
     [5563, 1650, 100, 100,'images/kumo10.png'],
     [6020, 1400, 100, 400,]
    ].each do |x,y,w,h, image_name|
     add_obj(Block.new(x,y,w,h,  image:image_name))
    end

    #シーン切り替えのフラグとイメージ
    @font = Font.new(32)
    @f = false
    @g = false
    @image_clear = Image.load('images/clear.png')
    @image_over = Image.load('images/gameover.png')

    #セットコリジョン
    _set_collisions
  end

  # 当シーンにおける1フレームの処理を制御するコントローラメソッド
  def play
    #ウインドウ座標の基準値
    @rt.ox = if @ball.body.p.x >=500 && @ball.body.p.x <= 7440
                 @ball.body.p.x - 500
             elsif @ball.body.p.x >= 7440
                   7040
             else
                  0
             end

    if  @ball.body.p.y >= 1800
         @rt.oy = 1800
    elsif @ball.body.p.y >= 1200
      @rt.oy = 1200
    elsif @ball.body.p.y >= 600
      @rt.oy = 600
    else
      @rt.oy = 0
    end

    # 物理演算空間の時間を@speed分進める
    @space.step(@speed)
    #背景の描画
    @rt.draw_tile(0,0,[[0],[1]],[@bg_image_haikei,@bg_image_sora],0,0,nil,nil,0)
    @rt.draw_tile(0,1180,[[0]],[@bg_image_tuta],0,0,78,1,10) #一回用
    @rt.draw_tile(0,560,[[0]],[@bg_image_tuta],0,0,nil,1,10) #2階用
    @rt.draw_tile(8015,1050,[[0]],[@bg_image_kabe],0,0,1,12,10) #壁右壁
    @rt.draw_tile(0,0,[[0]],[@bg_image_kabe],0,0,1,nil,8) #壁左側

    # 登録済みの全オブジェクトに対してdrawメソッドを呼び出し、画面に描画する
    # ※ @objectsに登録する全てのオブジェクトは、必ずdrawメソッドを実装していることを前提としている点に留意
    @objects.values.each {|obj| obj.draw(@rt) }
          Window.draw(0, 0, @rt)

    #残機さん
    Window.draw_font(25, 20, "zanki#{@ball.zanki}", @font)

    #クリア判定
    if @ball.zanki < 0
        Window.draw(0, 0, @image_over)

    elsif @daruma[4].body.p.x.round >= 450 && @daruma[4].body.p.x.round <= 750 && @daruma[4].body.p.y.round >= 1100
        @f = true

    elsif @daruma[4].body.p.x.round < 450|| @daruma[4].body.p.x.round > 750 && @daruma[4].body.p.y.round >= 1100
        @g = true
    end

    if @f == true
      Window.draw(0, 0, @image_clear)
    end

    if @g == true
      Window.draw(0, 0, @image_over)
    end

  end


  private

  # 物理演算空間（並びに描画対象格納配列）にオブジェクトを登録
  def add_obj(obj)
    @objects[obj.shape] = obj
    obj.add_to(@space)
  end

  # 物理演算空間（並びに描画対象格納配列）からオブジェクトを削除
  def remove_obj(shape)
    @objects[shape].remove_from(@space)
    @objects.delete(shape)
  end

  # 当たり判定を設定する
  def _set_collisions
    _set_collision_ball_and_daruma
    _set_collision_ball_and_ira
    _set_collision_ball_and_bane
    _set_collision_ball_and_warp
  end

  # ボールとアイテムの衝突判定追加
  # add_collision_handlerのブロック変数はそれぞれ衝突元（第1引数のcollision_typeに該当するオブジェクト（に含まれるShape）、
  # 衝突先（第2引数の対象オブジェクトのShape）、Arbiterオブジェクト（衝突内容の詳細を保持するオブジェクト）が入る。
  # 以下の点に留意。
  # * ブロック変数の頭2つは、Shapeオブジェクトが入るのであって、Wall/Box/Ballクラスのインスタンスではない
  # * Arbiterオブジェクトは、衝突した両者の接合点（衝突した個所）など、ゲーム作成に有用な情報を多数保持している。
  # ※ Arbiterの詳細などは、http://www.rubydoc.info/github/beoran/chipmunk/toplevel を参照
  def _set_collision_ball_and_daruma
    @space.add_collision_handler(Ball::DEFAULT_COLLISION_TYPE, Daruma::DEFAULT_COLLISION_TYPE) do |ball, box, arb|
      @space.add_post_step_callback(box) do |_, shape|

        ball.body.p = CP::Vec2.new(1000, 1150)
        ball.body.v = (vec2(0,0))
        ball.body.moment = (1)
      end
    end
  end

  #ボールとイライラ棒の衝突判定　ぶつかるとスタート地点に戻る
  def _set_collision_ball_and_ira
    @space.add_collision_handler(Ball::DEFAULT_COLLISION_TYPE, Ira::DEFAULT_COLLISION_TYPE) do |ball, box, arb|
      @space.add_post_step_callback(ball) do |_, shape|

        @ball.zanki_minus
        ball.body.p = CP::Vec2.new(50, 1750)
        ball.body.v = (vec2(0,0))
        ball.body.moment = (1)
      end
    end
  end

  #ボールと跳ね返る箱の衝突判定　ぶつかるとベクトルを2倍にして返す
  def _set_collision_ball_and_bane
    @space.add_collision_handler(Ball::DEFAULT_COLLISION_TYPE, Bane::DEFAULT_COLLISION_TYPE) do |ball, box, arb|
      @space.add_post_step_callback(ball) do |_, shape|

        ball.body.v = ball.body.v * 2
        ball.body.moment = (1)
      end
    end
  end

  #ボールとワープオブジェクトの衝突判定　ぶつかるとスタート地点に戻る
  def _set_collision_ball_and_warp
    @space.add_collision_handler(Ball::DEFAULT_COLLISION_TYPE, Warp::DEFAULT_COLLISION_TYPE) do |ball, goal, arb|
      @space.add_post_step_callback(goal) do |_, shape|

       ball.body.p = CP::Vec2.new(50, 1750)
       ball.body.v = (vec2(0,0))
       ball.body.moment = (1)
     end
   end
  end
end
