# Cart Management Test Script

# Testing Customer adding items to Cart (Single Restaurant Rule)

## Scenario: Customer adds items from same restaurant

### 1. Customer login and get restaurants

POST /api/auth/login
{
"email": "customer@example.com",
"password": "password"
}

GET /api/restaurants/nearby?latitude=10.762622&longitude=106.660172

### 2. Get menu items from Restaurant ID: 1

GET /api/restaurants/1/menu

### 3. Add first item to cart (Pizza Margherita - ID: 1)

POST /api/cart/add
Authorization: Bearer {token}
{
"restaurantId": 1,
"menuItemId": 1,
"quantity": 2,
"specialInstructions": "Extra cheese please"
}

### 4. Add second item from same restaurant (Pasta Carbonara - ID: 2)

POST /api/cart/add
Authorization: Bearer {token}
{
"restaurantId": 1,
"menuItemId": 2,
"quantity": 1,
"addOns": [
{
"menuItemAddOnId": 1,
"name": "Extra Bacon",
"price": 15000
}
]
}

### 5. Get current cart status

GET /api/cart
Authorization: Bearer {token}

### 6. Try to add item from different restaurant (Should clear cart)

POST /api/cart/add
Authorization: Bearer {token}
{
"restaurantId": 2,
"menuItemId": 5,
"quantity": 1
}

### 7. Verify cart now only contains item from Restaurant 2

GET /api/cart
Authorization: Bearer {token}

## Expected Results:

- ✅ Cart allows multiple items from same restaurant
- ✅ Cart automatically clears when switching restaurants
- ✅ Total amount calculated correctly with add-ons
- ✅ Item quantities can be updated
- ✅ Special instructions preserved
