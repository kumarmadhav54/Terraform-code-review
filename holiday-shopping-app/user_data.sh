#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd

cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Holiday Shopping Extravaganza</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f0f8ff;
            color: #333;
            margin: 0;
            padding: 0;
            text-align: center;
        }
        header {
            background-color: #d32f2f;
            color: white;
            padding: 2rem 0;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        h1 { margin: 0; font-size: 2.5rem; }
        .hero {
            background: linear-gradient(rgba(255,255,255,0.9), rgba(255,255,255,0.9)), url('https://images.unsplash.com/photo-1512389142860-9c449e58a543?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80');
            background-size: cover;
            padding: 4rem 1rem;
            margin-bottom: 2rem;
        }
        .products {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 2rem;
            padding: 2rem;
            max-width: 1200px;
            margin: 0 auto;
        }
        .product-card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            width: 300px;
            overflow: hidden;
            transition: transform 0.3s ease;
        }
        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        .product-image {
            height: 200px;
            background-color: #eee;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3rem;
        }
        .product-info {
            padding: 1.5rem;
        }
        .price {
            color: #d32f2f;
            font-weight: bold;
            font-size: 1.25rem;
        }
        .btn {
            display: inline-block;
            background-color: #2e7d32;
            color: white;
            padding: 0.5rem 1rem;
            text-decoration: none;
            border-radius: 4px;
            margin-top: 1rem;
            transition: background 0.3s;
        }
        .btn:hover { background-color: #1b5e20; }
        footer {
            background-color: #333;
            color: white;
            padding: 1rem;
            margin-top: 2rem;
        }
    </style>
</head>
<body>

    <header>
        <h1>🎁 Holiday Shop 2025 🎄</h1>
        <p>Find the perfect gifts for your loved ones!</p>
    </header>

    <div class="hero">
        <h2>Season's Greetings & Happy Shopping!</h2>
        <p>Huge discounts on all winter collection items.</p>
    </div>

    <div class="products">
        <div class="product-card">
            <div class="product-image">🧣</div>
            <div class="product-info">
                <h3>Cozy Scarf</h3>
                <p>Keep warm in style this winter.</p>
                <p class="price">$24.99</p>
                <a href="#" class="btn">Add to Cart</a>
            </div>
        </div>
        <div class="product-card">
            <div class="product-image">🧸</div>
            <div class="product-info">
                <h3>Teddy Bear</h3>
                <p>The perfect cuddly gift for kids.</p>
                <p class="price">$19.99</p>
                <a href="#" class="btn">Add to Cart</a>
            </div>
        </div>
        <div class="product-card">
            <div class="product-image">☕</div>
            <div class="product-info">
                <h3>Holiday Mug</h3>
                <p>For your hot cocoa and tea.</p>
                <p class="price">$12.50</p>
                <a href="#" class="btn">Add to Cart</a>
            </div>
        </div>
    </div>

    <footer>
        <p>&copy; 2025 Holiday Shopping App. All rights reserved.</p>
    </footer>

</body>
</html>
EOF
