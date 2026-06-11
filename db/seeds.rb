puts "Cleaning database..."

%w[
  AnalyticsEvent
  OrderItem
  Order
  CartItem
  Cart
  Favorite
  Like
  ProductVariant
  Product
  Section
  Category
  Gender
  NavbarPromotion
  Address
  User
].each do |class_name|
  klass = class_name.safe_constantize
  next unless klass

  puts "Deleting #{class_name}..."
  klass.destroy_all
end

puts "Creating users..."

admin = User.create!(
  email: "admin@appclothes.com",
  password: "123456",
  first_name: "Admin",
  last_name: "Store",
  phone: "(11) 99999-9999",
  role: :admin
)

customer = User.create!(
  email: "cliente@appclothes.com",
  password: "123456",
  first_name: "Cliente",
  last_name: "Teste",
  phone: "(11) 98888-8888",
  role: :customer
)

puts "Creating genders..."

feminino = Gender.create!(
  name: "Feminino",
  slug: "feminino",
  position: 1,
  active: true
)

masculino = Gender.create!(
  name: "Masculino",
  slug: "masculino",
  position: 2,
  active: true
)

infantil = Gender.create!(
  name: "Infantil",
  slug: "infantil",
  position: 3,
  active: true
)

puts "Creating navbar promotion..."

NavbarPromotion.create!(
  text: "Até 40% OFF♡",
  link_url: "/products?section=promocoes",
  position: 1,
  active: true
)

puts "Creating categories..."

categories = {
  lingerie_feminina: Category.create!(
    name: "Lingerie",
    slug: "lingerie-feminina",
    gender: feminino,
    position: 1,
    active: true
  ),

  conjuntos_femininos: Category.create!(
    name: "Conjuntos",
    slug: "conjuntos-femininos",
    gender: feminino,
    position: 2,
    active: true
  ),

  bodies_femininos: Category.create!(
    name: "Bodies",
    slug: "bodies-femininos",
    gender: feminino,
    position: 3,
    active: true
  ),

  pijamas_femininos: Category.create!(
    name: "Pijamas",
    slug: "pijamas-femininos",
    gender: feminino,
    position: 4,
    active: true
  ),

  robes_femininos: Category.create!(
    name: "Robes",
    slug: "robes-femininos",
    gender: feminino,
    position: 5,
    active: true
  ),

  cuecas_masculinas: Category.create!(
    name: "Cuecas",
    slug: "cuecas-masculinas",
    gender: masculino,
    position: 1,
    active: true
  ),

  pijamas_masculinos: Category.create!(
    name: "Pijamas",
    slug: "pijamas-masculinos",
    gender: masculino,
    position: 2,
    active: true
  ),

  camisetas_masculinas: Category.create!(
    name: "Camisetas",
    slug: "camisetas-masculinas",
    gender: masculino,
    position: 3,
    active: true
  ),

  meias_masculinas: Category.create!(
    name: "Meias",
    slug: "meias-masculinas",
    gender: masculino,
    position: 4,
    active: true
  ),

  pijamas_infantis: Category.create!(
    name: "Pijamas",
    slug: "pijamas-infantis",
    gender: infantil,
    position: 1,
    active: true
  ),

  conjuntos_infantis: Category.create!(
    name: "Conjuntos",
    slug: "conjuntos-infantis",
    gender: infantil,
    position: 2,
    active: true
  ),

  meias_infantis: Category.create!(
    name: "Meias",
    slug: "meias-infantis",
    gender: infantil,
    position: 3,
    active: true
  )
}

puts "Creating sections..."

sections = {
  novidades: Section.create!(
    name: "Novidades",
    slug: "novidades",
    position: 1,
    active: true
  ),

  destaques: Section.create!(
    name: "Destaques da semana",
    slug: "destaques-da-semana",
    position: 2,
    active: true
  ),

  conforto: Section.create!(
    name: "Conforto diário",
    slug: "conforto-diario",
    position: 3,
    active: true
  ),

  premium: Section.create!(
    name: "Coleção premium",
    slug: "colecao-premium",
    position: 4,
    active: true
  ),

  promocao: Section.create!(
    name: "Promoções",
    slug: "promocoes",
    position: 5,
    active: true
  )
}

def create_product(name:, description:, price_cents:, category:, section:, featured:, variants:)
  product = Product.create!(
    name: name,
    slug: name.parameterize,
    description: description,
    base_price_cents: price_cents,
    category: category,
    section: section,
    active: true,
    featured: featured
  )

  variants.each do |variant|
    sku = [
      product.slug,
      variant[:size],
      variant[:color].parameterize
    ].join("-").upcase

    ProductVariant.create!(
      product: product,
      size: variant[:size],
      color: variant[:color],
      sku: sku,
      stock_quantity: variant[:stock],
      price_cents: variant[:price_cents] || price_cents,
      active: true
    )
  end

  product
end

puts "Creating products..."

products_data = [
  {
    name: "Conjunto Aurora",
    description: "Conjunto delicado com acabamento premium, pensado para unir conforto, elegância e uso versátil no dia a dia.",
    price_cents: 12990,
    category: categories[:conjuntos_femininos],
    section: sections[:novidades],
    featured: true,
    variants: [
      { size: "P", color: "Preto", stock: 8 },
      { size: "M", color: "Preto", stock: 12 },
      { size: "G", color: "Preto", stock: 6 },
      { size: "M", color: "Branco", stock: 5 }
    ]
  },
  {
    name: "Conjunto Serena",
    description: "Modelo leve e confortável, com visual clean e acabamento suave para uma experiência agradável de uso.",
    price_cents: 9990,
    category: categories[:conjuntos_femininos],
    section: sections[:conforto],
    featured: true,
    variants: [
      { size: "P", color: "Branco", stock: 10 },
      { size: "M", color: "Branco", stock: 10 },
      { size: "G", color: "Branco", stock: 4 },
      { size: "GG", color: "Branco", stock: 3 }
    ]
  },
  {
    name: "Body Elegance",
    description: "Body com caimento elegante, acabamento estruturado e proposta sofisticada para composições versáteis.",
    price_cents: 15990,
    category: categories[:bodies_femininos],
    section: sections[:premium],
    featured: true,
    variants: [
      { size: "P", color: "Preto", stock: 6 },
      { size: "M", color: "Preto", stock: 8 },
      { size: "G", color: "Preto", stock: 4 }
    ]
  },
  {
    name: "Pijama Cloud Feminino",
    description: "Pijama de toque macio, com modelagem confortável e proposta ideal para noites tranquilas.",
    price_cents: 17990,
    category: categories[:pijamas_femininos],
    section: sections[:conforto],
    featured: true,
    variants: [
      { size: "P", color: "Rosa", stock: 7 },
      { size: "M", color: "Rosa", stock: 11 },
      { size: "G", color: "Rosa", stock: 5 },
      { size: "GG", color: "Rosa", stock: 3 }
    ]
  },
  {
    name: "Robe Belle",
    description: "Robe leve com acabamento elegante, ideal para compor momentos de descanso com estilo.",
    price_cents: 19990,
    category: categories[:robes_femininos],
    section: sections[:premium],
    featured: true,
    variants: [
      { size: "P", color: "Champagne", stock: 4 },
      { size: "M", color: "Champagne", stock: 6 },
      { size: "G", color: "Champagne", stock: 3 }
    ]
  },
  {
    name: "Sutiã Essential",
    description: "Sutiã básico com proposta confortável, acabamento discreto e boa sustentação para o uso diário.",
    price_cents: 8990,
    category: categories[:lingerie_feminina],
    section: sections[:conforto],
    featured: false,
    variants: [
      { size: "P", color: "Preto", stock: 8 },
      { size: "M", color: "Preto", stock: 12 },
      { size: "G", color: "Preto", stock: 7 },
      { size: "GG", color: "Preto", stock: 4 }
    ]
  },
  {
    name: "Cueca Boxer Classic",
    description: "Cueca boxer confortável para o dia a dia, com tecido macio e ótimo ajuste ao corpo.",
    price_cents: 4990,
    category: categories[:cuecas_masculinas],
    section: sections[:conforto],
    featured: true,
    variants: [
      { size: "P", color: "Preto", stock: 16 },
      { size: "M", color: "Preto", stock: 20 },
      { size: "G", color: "Preto", stock: 14 },
      { size: "GG", color: "Preto", stock: 8 }
    ]
  },
  {
    name: "Cueca Slip Essential",
    description: "Modelo slip com visual discreto, ajuste confortável e acabamento resistente.",
    price_cents: 3990,
    category: categories[:cuecas_masculinas],
    section: sections[:promocao],
    featured: false,
    variants: [
      { size: "P", color: "Cinza", stock: 14 },
      { size: "M", color: "Cinza", stock: 18 },
      { size: "G", color: "Cinza", stock: 13 },
      { size: "GG", color: "Cinza", stock: 6 }
    ]
  },
  {
    name: "Pijama Masculino Comfort",
    description: "Pijama masculino com modelagem confortável para noites tranquilas e uso casual em casa.",
    price_cents: 15990,
    category: categories[:pijamas_masculinos],
    section: sections[:novidades],
    featured: true,
    variants: [
      { size: "P", color: "Azul marinho", stock: 6 },
      { size: "M", color: "Azul marinho", stock: 10 },
      { size: "G", color: "Azul marinho", stock: 8 },
      { size: "GG", color: "Azul marinho", stock: 4 }
    ]
  },
  {
    name: "Camiseta Homewear Masculina",
    description: "Camiseta leve e macia para momentos de descanso, com visual minimalista e confortável.",
    price_cents: 7990,
    category: categories[:camisetas_masculinas],
    section: sections[:conforto],
    featured: false,
    variants: [
      { size: "P", color: "Branco", stock: 10 },
      { size: "M", color: "Branco", stock: 14 },
      { size: "G", color: "Branco", stock: 9 },
      { size: "GG", color: "Branco", stock: 5 }
    ]
  },
  {
    name: "Pijama Infantil Nuvem",
    description: "Pijama infantil confortável, com toque macio e visual delicado para noites tranquilas.",
    price_cents: 9990,
    category: categories[:pijamas_infantis],
    section: sections[:novidades],
    featured: true,
    variants: [
      { size: "2", color: "Azul claro", stock: 6 },
      { size: "4", color: "Azul claro", stock: 8 },
      { size: "6", color: "Azul claro", stock: 5 },
      { size: "8", color: "Azul claro", stock: 4 }
    ]
  },
  {
    name: "Conjunto Infantil Soft",
    description: "Conjunto infantil para descanso e rotina, com modelagem confortável e tecido leve.",
    price_cents: 11990,
    category: categories[:conjuntos_infantis],
    section: sections[:conforto],
    featured: false,
    variants: [
      { size: "2", color: "Rosa", stock: 5 },
      { size: "4", color: "Rosa", stock: 7 },
      { size: "6", color: "Rosa", stock: 5 },
      { size: "8", color: "Rosa", stock: 3 }
    ]
  },
  {
    name: "Kit Meias Infantil",
    description: "Kit de meias infantis com toque macio, ideal para uso diário.",
    price_cents: 3990,
    category: categories[:meias_infantis],
    section: sections[:promocao],
    featured: false,
    variants: [
      { size: "2-4", color: "Colorido", stock: 12 },
      { size: "6-8", color: "Colorido", stock: 10 },
      { size: "10-12", color: "Colorido", stock: 8 }
    ]
  }
]

created_products = products_data.map do |data|
  create_product(**data)
end

puts "Creating cart..."

Cart.create!(
  user: customer,
  status: "active"
)

puts "Creating sample likes and favorites..."

created_products.sample(8).each do |product|
  Like.find_or_create_by!(user: customer, product: product)
end

created_products.sample(6).each do |product|
  Favorite.find_or_create_by!(user: customer, product: product)
end

puts "Done!"
puts "Created #{User.count} users"
puts "Created #{Gender.count} genders"
puts "Created #{Category.count} categories"
puts "Created #{Section.count} sections"
puts "Created #{NavbarPromotion.count} navbar promotions"
puts "Created #{Product.count} products"
puts "Created #{ProductVariant.count} product variants"
puts ""
puts "Admin login: admin@appclothes.com / 123456"
puts "Customer login: cliente@appclothes.com / 123456"
