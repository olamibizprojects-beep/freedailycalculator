#!/bin/bash
# FinanceTools Pro - Deployment Script
# Run this in your project directory after downloading files

echo "=========================================="
echo "  FinanceTools Pro Deployment Script"
echo "=========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if files exist
if [ ! -f "index.html" ]; then
    print_error "index.html not found! Please run this script in the project directory."
    exit 1
fi

print_success "Found index.html ($(wc -c < index.html | numfmt --to=iec)B)"

# Menu
echo ""
echo "Choose deployment method:"
echo "  1) Netlify (Easiest - Drag & Drop)"
echo "  2) Vercel (Full Stack + AI Chat)"
echo "  3) GitHub Pages (Free Static Hosting)"
echo "  4) Cloudflare Pages (Fastest CDN)"
echo "  5) VPS/Dedicated Server (Full Control)"
echo "  6) Just prepare files for manual upload"
echo ""
read -p "Enter choice (1-6): " choice

case $choice in
    1)
        echo ""
        print_status "Preparing for Netlify deployment..."

        # Create _redirects file for SPA routing
        echo "/* /index.html 200" > _redirects
        print_success "Created _redirects file for SPA routing"

        # Create netlify.toml
        cat > netlify.toml << 'EOF'
[build]
  publish = "."

[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200

[headers]
  for = "/*"
  [headers.values]
    X-Frame-Options = "DENY"
    X-Content-Type-Options = "nosniff"
    Referrer-Policy = "strict-origin-when-cross-origin"

[[headers]]
  for = "*.html"
  [headers.values]
    Cache-Control = "public, max-age=0, must-revalidate"

[[headers]]
  for = "*.js"
  [headers.values]
    Cache-Control = "public, max-age=31536000, immutable"

[[headers]]
  for = "*.css"
  [headers.values]
    Cache-Control = "public, max-age=31536000, immutable"
EOF
        print_success "Created netlify.toml with security headers"

        echo ""
        echo "=========================================="
        echo "  Netlify Deployment Steps:"
        echo "=========================================="
        echo ""
        echo "1. Go to https://app.netlify.com/drop"
        echo "2. Drag this entire folder onto the page"
        echo "3. Wait 30 seconds for deployment"
        echo "4. Click 'Site settings' → 'Domain management'"
        echo "5. Add your custom domain"
        echo "6. Enable HTTPS (auto-SSL)"
        echo ""
        echo "OR use Netlify CLI:"
        echo "   npm install -g netlify-cli"
        echo "   netlify deploy --prod --dir=."
        echo ""
        print_success "Files ready for Netlify!"
        ;;

    2)
        echo ""
        print_status "Preparing for Vercel deployment..."

        # Create vercel.json
        cat > vercel.json << 'EOF'
{
  "version": 2,
  "builds": [
    { "src": "server.js", "use": "@vercel/node" }
  ],
  "routes": [
    { "src": "/api/(.*)", "dest": "/server.js" },
    { "src": "/(.*)", "dest": "/index.html" }
  ],
  "headers": [
    {
      "source": "/(.*)",
      "headers": [
        { "key": "X-Frame-Options", "value": "DENY" },
        { "key": "X-Content-Type-Options", "value": "nosniff" }
      ]
    }
  ]
}
EOF
        print_success "Created vercel.json"

        echo ""
        echo "=========================================="
        echo "  Vercel Deployment Steps:"
        echo "=========================================="
        echo ""
        echo "1. Install Vercel CLI:"
        echo "   npm i -g vercel"
        echo ""
        echo "2. Login and deploy:"
        echo "   vercel login"
        echo "   vercel --prod"
        echo ""
        echo "3. Set environment variables in dashboard:"
        echo "   DEEPSEEK_API_KEY=sk-05bc8a86ded1487b9930f9637d6354b2"
        echo "   ALLOWED_ORIGINS=https://yourdomain.com"
        echo ""
        echo "4. Add custom domain in Project Settings"
        echo ""
        print_success "Files ready for Vercel!"
        ;;

    3)
        echo ""
        print_status "Preparing for GitHub Pages..."

        # Create .nojekyll to bypass Jekyll processing
        touch .nojekyll
        print_success "Created .nojekyll file"

        echo ""
        echo "=========================================="
        echo "  GitHub Pages Deployment Steps:"
        echo "=========================================="
        echo ""
        echo "1. Create new repository on GitHub"
        echo "2. Push files:"
        echo "   git init"
        echo "   git add ."
        echo "   git commit -m 'Initial deployment'"
        echo "   git branch -M main"
        echo "   git remote add origin https://github.com/YOURNAME/financetools.git"
        echo "   git push -u origin main"
        echo ""
        echo "3. Go to Settings → Pages → Source: Deploy from branch"
        echo "4. Select 'main' branch and '/' folder"
        echo "5. Wait 2-3 minutes for deployment"
        echo "6. Site will be at: https://yourname.github.io/financetools"
        echo ""
        echo "NOTE: GitHub Pages is STATIC ONLY (no AI chat backend)"
        echo "      For AI chat, use Netlify/Vercel/VPS instead"
        echo ""
        print_success "Files ready for GitHub Pages!"
        ;;

    4)
        echo ""
        print_status "Preparing for Cloudflare Pages..."

        # Create _routes.json for Cloudflare
        cat > _routes.json << 'EOF'
{
  "version": 1,
  "include": ["/api/*"],
  "exclude": ["/*"]
}
EOF
        print_success "Created _routes.json"

        echo ""
        echo "=========================================="
        echo "  Cloudflare Pages Deployment Steps:"
        echo "=========================================="
        echo ""
        echo "1. Go to https://dash.cloudflare.com"
        echo "2. Pages → Create a project → Connect to Git"
        echo "3. Select your repository"
        echo "4. Build settings:"
        echo "   Framework preset: None"
        echo "   Build command: (leave empty)"
        echo "   Build output directory: /"
        echo "5. Add environment variables:"
        echo "   DEEPSEEK_API_KEY=sk-05bc8a86ded1487b9930f9637d6354b2"
        echo "6. Save and deploy"
        echo "7. Add custom domain in Pages settings"
        echo ""
        print_success "Files ready for Cloudflare Pages!"
        ;;

    5)
        echo ""
        print_status "Preparing for VPS deployment..."

        # Create deployment script for VPS
        cat > deploy-vps.sh << 'EOFVPS'
#!/bin/bash
# VPS Deployment Script - Run on your server

echo "Installing dependencies..."
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs nginx git

echo "Installing PM2..."
sudo npm install -g pm2

echo "Cloning repository..."
cd /var/www
git clone https://github.com/YOURNAME/financetools.git
cd financetools

echo "Installing Node modules..."
npm install

echo "Creating .env file..."
cat > .env << 'ENVEOF'
DEEPSEEK_API_KEY=sk-05bc8a86ded1487b9930f9637d6354b2
ALLOWED_ORIGINS=https://yourdomain.com
PORT=3000
ENVEOF

echo "Starting with PM2..."
pm2 start server.js --name "financetools"
pm2 startup
pm2 save

echo "Configuring Nginx..."
sudo tee /etc/nginx/sites-available/financetools << 'NGINX'
server {
    listen 80;
    server_name yourdomain.com www.yourdomain.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name yourdomain.com;

    ssl_certificate /etc/letsencrypt/live/yourdomain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/yourdomain.com/privkey.pem;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }

    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml;
}
NGINX

sudo ln -s /etc/nginx/sites-available/financetools /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx

echo "Installing SSL with Certbot..."
sudo apt-get install -y certbot python3-certbot-nginx
sudo certbot --nginx -d yourdomain.com -d www.yourdomain.com

echo "Done! Your site should be live at https://yourdomain.com"
EOFVPS
        chmod +x deploy-vps.sh
        print_success "Created deploy-vps.sh for server setup"

        echo ""
        echo "=========================================="
        echo "  VPS Deployment Steps:"
        echo "=========================================="
        echo ""
        echo "1. Get a VPS (DigitalOcean, Linode, AWS, Vultr)"
        echo "   Recommended: $5-10/month Ubuntu 22.04"
        echo ""
        echo "2. SSH into your server:"
        echo "   ssh root@YOUR_SERVER_IP"
        echo ""
        echo "3. Upload files:"
        echo "   scp -r . root@YOUR_SERVER_IP:/var/www/"
        echo ""
        echo "4. Run deployment script:"
        echo "   cd /var/www"
        echo "   bash deploy-vps.sh"
        echo ""
        echo "5. Update DNS A record to point to your server IP"
        echo ""
        print_success "VPS deployment files ready!"
        ;;

    6)
        echo ""
        print_status "Creating optimized deployment package..."

        # Create a clean zip for manual upload
        mkdir -p deploy-package
        cp index.html deploy-package/
        cp server.js deploy-package/
        cp package.json deploy-package/
        cp .env.example deploy-package/
        cp robots.txt deploy-package/
        cp sitemap.xml deploy-package/
        cp ads.txt deploy-package/
        cp privacy.html deploy-package/
        cp terms.html deploy-package/
        cp disclaimer.html deploy-package/
        cp cookies.html deploy-package/
        cp DEPLOYMENT.md deploy-package/

        # Create _redirects for SPA
        echo "/* /index.html 200" > deploy-package/_redirects

        print_success "Created deploy-package/ folder with all files"
        echo ""
        echo "Upload these files to your hosting provider."
        ;;

    *)
        print_error "Invalid choice. Exiting."
        exit 1
        ;;
esac

echo ""
echo "=========================================="
echo "  Post-Deployment Checklist"
echo "=========================================="
echo ""
echo "□ Replace 'yourdomain.com' in all meta tags"
echo "□ Update canonical URLs in index.html"
echo "□ Set up Google Search Console"
echo "□ Submit sitemap.xml to Search Console"
echo "□ Add Google Analytics 4 tracking code"
echo "□ Update ads.txt with your AdSense Publisher ID"
echo "□ Write 5 blog posts (920+ words each)"
echo "□ Test all calculators on mobile"
echo "□ Run PageSpeed Insights (aim >90 mobile)"
echo "□ Apply for Google AdSense (after 30-60 days)"
echo ""
print_success "Deployment preparation complete!"
