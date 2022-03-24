module IconsHelper
  def fa_solid(icon, size: 2, options: {}, animate: false)
    tag.span(class: "icon #{options[:class]}", title: options[:title]) do
      tag.i(class: "fas fa-#{icon} fa-size-#{size} #{'fa-spin' if animate}")
    end
  end

  def fa_regular(icon, size: 2, options: {})
    tag.span(class: "icon #{options[:class]}", title: options[:title]) do
      tag.i(class: "far fa-#{icon} fa-size-#{size}")
    end
  end

  def fa_brands(icon, size: 2, options: {})
    tag.span(class: "icon #{options[:class]}", title: options[:title]) do
      tag.i(class: "fab fa-#{icon} fa-size-#{size}")
    end
  end
end
