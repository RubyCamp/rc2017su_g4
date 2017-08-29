class Ball < CPCircle
  DEFAULT_COLLISION_TYPE = 3
  DEFAULT_E = 0.4
  DEFAULT_U = 1.0
  CONTROL_SCALE_FACTOR = 3  # コントロール矢印がボールに与える加速度の補助係数


  def initialize(x, y, r, opt = {})
    super

    # ボールの物理特性を設定
    self.shape.e = opt[:shape_e] || DEFAULT_E  # 弾性係数（0.0 - 1.0）
    self.shape.u = opt[:shape_u] || DEFAULT_U  # 摩擦係数（0.0 - 1.0）
    self.shape.collision_type = opt[:collision_type] || DEFAULT_COLLISION_TYPE  # 衝突種別

    # コントロール用矢印画像読み込み
    @arrow = Image.load('images/arrow.png')

    # フラグ初期化
    @dragging = false  # ボールをドラッグ中にtrue化
    @dropped = false   # ボールをドロップした際にtrue化

    # コントロール矢印の属性
    @rad = 0  # 角度（ラジアン単位）
    @dst = 0  # 大きさ
  end

  def shape_default_image
    image = Image.load('images/hangrybird.png')
    image.set_color_key([255, 255, 255])
    image
  end

  # 描画メソッドオーバーライド
  # ボール画像描画後、operationメソッドを実行
  # ※ 1フレーム単位で本メソッドが処理されていることに留意
  def draw(rt)
    super
    operation(rt)

  if Input.key_push?(K_SPACE)
      @body.p = CP::Vec2.new(60, 1750)
      @body.v = (vec2(0,0))
      @body.moment = (1)

   end
  end

  private

  #左クリックで飛ぶメソッド
  def operation(rt)

    #左クリックをすると
    if  Input.mouse_down?(M_LBUTTON)

     # ボールの現在位置と、マウス座標を確保し、それぞれコントロール矢印の始点・終点座標として用いる
      x, y, x2, y2 = @body.p.x, @body.p.y, rt.ox + Input.mouse_x , rt.oy + Input.mouse_y

      # 始点・終点座標から、コントロールの角度を求める
      @rad = Math.atan2(y2 - y,x2 - x)              # 一旦、逆正接を取ってラジアン角を得て…
      deg = ( @rad * 180.0 / Math::PI )                 # DxRubyでの描画のため、度単位に変換
      @dst = Math.sqrt((x2 - x) ** 2 + (y2 - y) ** 2) # 三平方の定理により、コントロール矢印の大きさを得る

      #飛ぶ方向ベクトルのx成分,y成分、速度ベクトル
      dx = @dst * Math.cos(@rad)
      dy = @dst * Math.sin(@rad)
      @body.v = (vec2(dx, dy) * CONTROL_SCALE_FACTOR)

    end
  end
end