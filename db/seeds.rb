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

puts "Creating categories..."

categories = {
  lingerie: Category.create!(
    name: "Lingerie",
    slug: "lingerie",
    position: 1,
    active: true
  ),

  conjuntos: Category.create!(
    name: "Conjuntos",
    slug: "conjuntos",
    position: 2,
    active: true
  ),

  bodies: Category.create!(
    name: "Bodies",
    slug: "bodies",
    position: 3,
    active: true
  ),

  pijamas: Category.create!(
    name: "Pijamas",
    slug: "pijamas",
    position: 4,
    active: true
  ),

  robes: Category.create!(
    name: "Robes",
    slug: "robes",
    position: 5,
    active: true
  ),

  basicos: Category.create!(
    name: "Básicos",
    slug: "basicos",
    position: 6,
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
    category: categories[:conjuntos],
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
    category: categories[:conjuntos],
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
    name: "Conjunto Luna",
    description: "Peça com design moderno e detalhes sutis, ideal para quem busca sofisticação sem abrir mão do conforto.",
    price_cents: 13990,
    category: categories[:conjuntos],
    section: sections[:premium],
    featured: true,
    variants: [
      { size: "P", color: "Vinho", stock: 4 },
      { size: "M", color: "Vinho", stock: 7 },
      { size: "G", color: "Vinho", stock: 5 },
      { size: "M", color: "Nude", stock: 6 }
    ]
  },
  {
    name: "Body Elegance",
    description: "Body com caimento elegante, acabamento estruturado e proposta sofisticada para composições versáteis.",
    price_cents: 15990,
    category: categories[:bodies],
    section: sections[:premium],
    featured: true,
    variants: [
      { size: "P", color: "Preto", stock: 6 },
      { size: "M", color: "Preto", stock: 8 },
      { size: "G", color: "Preto", stock: 4 }
    ]
  },
  {
    name: "Body Amelie",
    description: "Modelo confortável com visual refinado, pensado para valorizar produções casuais e elegantes.",
    price_cents: 14990,
    category: categories[:bodies],
    section: sections[:novidades],
    featured: false,
    variants: [
      { size: "P", color: "Nude", stock: 5 },
      { size: "M", color: "Nude", stock: 9 },
      { size: "G", color: "Nude", stock: 5 },
      { size: "GG", color: "Nude", stock: 2 }
    ]
  },
  {
    name: "Body Minimal",
    description: "Body básico com acabamento discreto, ideal para quem procura uma peça funcional e fácil de combinar.",
    price_cents: 11990,
    category: categories[:bodies],
    section: sections[:conforto],
    featured: false,
    variants: [
      { size: "P", color: "Preto", stock: 10 },
      { size: "M", color: "Preto", stock: 12 },
      { size: "G", color: "Preto", stock: 8 },
      { size: "GG", color: "Preto", stock: 4 }
    ]
  },
  {
    name: "Pijama Cloud",
    description: "Pijama de toque macio, com modelagem confortável e proposta ideal para noites tranquilas.",
    price_cents: 17990,
    category: categories[:pijamas],
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
    name: "Pijama Noite Serena",
    description: "Conjunto de dormir com visual delicado, tecido confortável e acabamento pensado para uso prolongado.",
    price_cents: 18990,
    category: categories[:pijamas],
    section: sections[:novidades],
    featured: false,
    variants: [
      { size: "P", color: "Azul claro", stock: 4 },
      { size: "M", color: "Azul claro", stock: 8 },
      { size: "G", color: "Azul claro", stock: 6 }
    ]
  },
  {
    name: "Pijama Essencial",
    description: "Modelo básico, confortável e prático para a rotina, com excelente custo-benefício.",
    price_cents: 12990,
    category: categories[:pijamas],
    section: sections[:promocao],
    featured: false,
    variants: [
      { size: "P", color: "Cinza", stock: 10 },
      { size: "M", color: "Cinza", stock: 13 },
      { size: "G", color: "Cinza", stock: 9 },
      { size: "GG", color: "Cinza", stock: 4 }
    ]
  },
  {
    name: "Robe Belle",
    description: "Robe leve com acabamento elegante, ideal para compor momentos de descanso com estilo.",
    price_cents: 19990,
    category: categories[:robes],
    section: sections[:premium],
    featured: true,
    variants: [
      { size: "P", color: "Champagne", stock: 4 },
      { size: "M", color: "Champagne", stock: 6 },
      { size: "G", color: "Champagne", stock: 3 }
    ]
  },
  {
    name: "Robe Soft",
    description: "Robe macio e confortável, com caimento leve e visual minimalista.",
    price_cents: 16990,
    category: categories[:robes],
    section: sections[:conforto],
    featured: false,
    variants: [
      { size: "P", color: "Off-white", stock: 5 },
      { size: "M", color: "Off-white", stock: 7 },
      { size: "G", color: "Off-white", stock: 4 },
      { size: "GG", color: "Off-white", stock: 2 }
    ]
  },
  {
    name: "Top Daily",
    description: "Top básico com sustentação confortável e visual discreto para uso cotidiano.",
    price_cents: 7990,
    category: categories[:basicos],
    section: sections[:conforto],
    featured: false,
    variants: [
      { size: "P", color: "Preto", stock: 15 },
      { size: "M", color: "Preto", stock: 18 },
      { size: "G", color: "Preto", stock: 12 },
      { size: "GG", color: "Preto", stock: 6 }
    ]
  },
  {
    name: "Top Cotton",
    description: "Top em proposta casual, com toque suave e modelagem pensada para conforto durante o dia.",
    price_cents: 6990,
    category: categories[:basicos],
    section: sections[:promocao],
    featured: false,
    variants: [
      { size: "P", color: "Branco", stock: 14 },
      { size: "M", color: "Branco", stock: 17 },
      { size: "G", color: "Branco", stock: 11 },
      { size: "GG", color: "Branco", stock: 5 }
    ]
  },
  {
    name: "Calcinha Comfort",
    description: "Peça básica com acabamento macio, ideal para quem valoriza conforto e praticidade.",
    price_cents: 3990,
    category: categories[:lingerie],
    section: sections[:conforto],
    featured: false,
    variants: [
      { size: "P", color: "Nude", stock: 20 },
      { size: "M", color: "Nude", stock: 25 },
      { size: "G", color: "Nude", stock: 18 },
      { size: "GG", color: "Nude", stock: 10 }
    ]
  },
  {
    name: "Calcinha Classic",
    description: "Modelo clássico com visual discreto, acabamento limpo e excelente opção para o dia a dia.",
    price_cents: 3490,
    category: categories[:lingerie],
    section: sections[:promocao],
    featured: false,
    variants: [
      { size: "P", color: "Preto", stock: 22 },
      { size: "M", color: "Preto", stock: 25 },
      { size: "G", color: "Preto", stock: 15 },
      { size: "GG", color: "Preto", stock: 8 }
    ]
  },
  {
    name: "Sutiã Essential",
    description: "Sutiã básico com proposta confortável, acabamento discreto e boa sustentação para o uso diário.",
    price_cents: 8990,
    category: categories[:lingerie],
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
    name: "Sutiã Soft Touch",
    description: "Modelo com toque suave e visual moderno, pensado para equilibrar conforto e estilo.",
    price_cents: 9990,
    category: categories[:lingerie],
    section: sections[:novidades],
    featured: false,
    variants: [
      { size: "P", color: "Rosa claro", stock: 7 },
      { size: "M", color: "Rosa claro", stock: 9 },
      { size: "G", color: "Rosa claro", stock: 5 }
    ]
  },
  {
    name: "Conjunto Florence",
    description: "Conjunto refinado com visual delicado, acabamento de qualidade e proposta elegante.",
    price_cents: 14990,
    category: categories[:conjuntos],
    section: sections[:premium],
    featured: true,
    variants: [
      { size: "P", color: "Azul marinho", stock: 4 },
      { size: "M", color: "Azul marinho", stock: 6 },
      { size: "G", color: "Azul marinho", stock: 3 },
      { size: "M", color: "Vinho", stock: 5 }
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
puts "Created #{Category.count} categories"
puts "Created #{Section.count} sections"
puts "Created #{Product.count} products"
puts "Created #{ProductVariant.count} product variants"
puts ""
puts "Admin login: admin@appclothes.com / 123456"
puts "Customer login: cliente@appclothes.com / 123456"
