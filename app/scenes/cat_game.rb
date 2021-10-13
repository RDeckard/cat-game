class CatGame < GTKObject
  def initialize(floor, mouse)
    @floor = floor
    @mouse = mouse

    gtk.hide_cursor
  end

  def tick
    @angle ||= 0

    render

    current_point = inputs.mouse.point.to_hash

    if @last_point && inputs.mouse.moved
      @angle = geometry.angle_to(@last_point, current_point)
    end

    if current_point.y < grid.bottom.shift_up(@mouse.w/2)
      @angle = 90
    elsif current_point.y > grid.top.shift_down(@mouse.w/2)
      @angle = 270
    end

    if current_point.x < grid.left.shift_right(@mouse.w/2)
      @angle = 0
    elsif current_point.x > grid.right.shift_left(@mouse.w/2)
      @angle = 180
    end

    @mouse.merge!(
      x: current_point.x - @mouse.w/2,
      y: current_point.y - @mouse.h/2,
      angle: @angle
    )

    @last_point = current_point if @last_point.nil? || geometry.distance(current_point, @last_point) >= 150
  end

  private

  def render
    return if @render

    outputs.static_primitives << [@floor, @mouse]

    @render = true
  end
end
