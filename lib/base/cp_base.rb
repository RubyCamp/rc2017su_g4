class CPBase
  attr_accessor :body, :shape, :width, :height

  # 物理演算空間へのオブジェクト登録を一括して行うメソッド
  def add_to(space)
    self.shape.add_to_space(space)
    self.body.add_to_space(space) unless self.body.class == CP::StaticBody # StaticBodyはspaceへ登録できないための条件づけ
  end

  # 物理演算空間からのオブジェクト削除を一括して行うメソッド
  def remove_from(space)
    self.shape.remove_from_space(space)
    self.body.remove_from_space(space) if self.body
  end

  private

  def set_image(img)
    if img
      @image = Image.load(img)
    else
      @image = shape_default_image
    end
  end

  # このメソッドを、個別の形状クラス毎にオーバーライドする
  # NOTE: Rubyにおける「最後に評価された式の値が戻り値になる」という特徴を使っている
  def shape_default_image
    Image.new(width, height, [96, 48, 3])
  end
end
