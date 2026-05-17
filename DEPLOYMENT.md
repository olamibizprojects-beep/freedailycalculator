# FinanceTools Pro - Deployment Guide

## 📦 Project Structure

```
financetools-pro/
├── index.html          # Main frontend (single-file SPA)
├── server.js           # Node.js backend proxy for DeepSeek AI
├── package.json        # Dependencies
├── .env.example        # Environment template
├── .gitignore         # Git ignore rules
├── robots.txt         # SEO crawler instructions
├── sitemap.xml        # Search engine sitemap
└── DEPLOYMENT.md      # This file
```

---

## 🚀 Quick Start (Local Development)

### Option A: Static Only (No AI Chat)
Simply open `index.html` in any browser or serve with any static server:

```bash
# Python 3
python -m http.server 8000

# Node.js (npx)
npx serve .

# PHP
php -S localhost:8000
```

### Option B: Full Stack (With AI Chat)

```bash
# 1. Install dependencies
npm install

# 2. Create environment file
cp .env.example .env

# 3. Edit .env and add your DeepSeek API key
# DEEPSEEK_API_KEY=sk-05bc8a86ded1487b9930f9637d6354b2

# 4. Start server
npm start

# Server runs at http://localhost:3000
```

---

## 🌐 Production Deployment

### 1. Netlify (Recommended for Frontend)

**Method A: Drag & Drop**
1. Go to [netlify.com](https://netlify.com)
2. Drag the project folder to deploy
3. Set custom domain in Site Settings
4. Add `_redirects` file for SPA routing:
   ```
   /*    /index.html   200
   ```

**Method B: Git Integration**
1. Push to GitHub/GitLab
2. Connect repo to Netlify
3. Build command: `echo "Static site"`
4. Publish directory: `/`

**Netlify Settings:**
- Enable HTTPS (auto-SSL)
- Enable asset optimization
- Set `Cache-Control: public, max-age=31536000` for static assets

### 2. Vercel (Recommended for Full Stack)

```bash
# Install Vercel CLI
npm i -g vercel

# Deploy
vercel

# Set environment variables in dashboard:
# DEEPSEEK_API_KEY=your_key
# ALLOWED_ORIGINS=https://yourdomain.com
```

**vercel.json configuration:**
```json
{
  "version": 2,
  "builds": [
    { "src": "server.js", "use": "@vercel/node" }
  ],
  "routes": [
    { "src": "/api/(.*)", "dest": "/server.js" },
    { "src": "/(.*)", "dest": "/index.html" }
  ]
}
```

### 3. Cloudflare Pages (Best for Speed)

1. Connect GitHub repo
2. Build settings:
   - Framework preset: None
   - Build command: None
   - Output directory: `/`
3. Add `_routes.json` for Functions:
   ```json
   {
     "version": 1,
     "include": ["/api/*"],
     "exclude": ["/*"]
   }
   ```

### 4. Traditional VPS (DigitalOcean, Linode, AWS EC2)

```bash
# On your server:
git clone <your-repo>
cd financetools-pro
npm install

# Create .env file with production values
nano .env

# Install PM2 for process management
npm install -g pm2

# Start with PM2
pm2 start server.js --name "financetools"
pm2 startup
pm2 save

# Configure Nginx reverse proxy
sudo nano /etc/nginx/sites-available/financetools
```

**Nginx Configuration:**
```nginx
server {
    listen 80;
    server_name yourdomain.com www.yourdomain.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name yourdomain.com;

    ssl_certificate /path/to/cert.pem;
    ssl_certificate_key /path/to/key.pem;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }

    # Gzip compression
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml;
}
```

---

## 🔑 Environment Variables

Create `.env` file in production:

```env
# Required for AI Chat feature
DEEPSEEK_API_KEY=sk-05bc8a86ded1487b9930f9637d6354b2

# Security
ALLOWED_ORIGINS=https://yourdomain.com,https://www.yourdomain.com

# Server
PORT=3000
```

**⚠️ SECURITY WARNING:**
- NEVER commit `.env` to Git
- NEVER expose API keys in client-side code
- The provided key should ONLY be used server-side via the proxy

---

## 📊 Google AdSense Setup

### Before Applying (Prerequisites)
1. **Custom Domain**: Must use your own domain (not subdomain of free host)
2. **HTTPS**: SSL certificate required
3. **Content Depth**: Add 5-10 blog posts (920+ words each)
4. **Legal Pages**: Create Privacy Policy, Terms, Disclaimer pages
5. **Navigation**: All pages accessible from homepage
6. **No Placeholder Content**: Replace all "Lorem ipsum" text
7. **Mobile Responsive**: Test on multiple devices

### Ad Unit Placement
Replace the placeholder `<div class="ad-slot">` elements with actual AdSense code:

```html
<!-- Example: Top Ad Unit -->
<div id="ad-slot-top">
  <script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-XXXXXXXXXXXXXXXX"
     crossorigin="anonymous"></script>
  <ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-XXXXXXXXXXXXXXXX"
     data-ad-slot="XXXXXXXXXX"
     data-ad-format="auto"
     data-full-width-responsive="true"></ins>
  <script>(adsbygoogle = window.adsbygoogle || []).push({});</script>
</div>
```

**Ad Placement Strategy:**
- **Top Banner**: Below hero section (high viewability)
- **Sidebar**: 300x250 or responsive (high CTR)
- **In-Content**: Between calculator inputs and results
- **Bottom**: After main content

**AdSense Policy Compliance:**
- Maximum 3 ads per page
- No ads near interactive elements (buttons, forms)
- No deceptive placement
- Content must be original and substantial
- No auto-refresh or pop-under ads

---

## 🔍 SEO Optimization Checklist

### Pre-Launch
- [ ] Replace `yourdomain.com` in all meta tags with actual domain
- [ ] Update `canonical` URL in `<head>`
- [ ] Update Open Graph and Twitter card URLs
- [ ] Update `og:image` with actual branded image (1200x630px)
- [ ] Verify `robots.txt` points to correct sitemap URL
- [ ] Submit sitemap to Google Search Console
- [ ] Verify site ownership in Search Console
- [ ] Add Google Analytics 4 tracking code

### Structured Data Verification
Test at: https://search.google.com/test/rich-results

### PageSpeed Insights Targets
- [ ] Mobile LCP < 2.5s
- [ ] Mobile FID < 100ms
- [ ] Mobile CLS < 0.1
- [ ] Desktop score > 90

### Content Strategy (Post-Launch)
- [ ] Publish 5 blog posts targeting long-tail keywords
- [ ] Example: "how to calculate loan interest manually"
- [ ] Example: "mortgage payoff calculator strategies"
- [ ] Internal linking between blog posts and calculators
- [ ] Add FAQ schema to popular calculators

---

## 🛡️ Security Checklist

- [ ] Enable HTTPS (Let's Encrypt free SSL)
- [ ] Set secure CORS headers in server.js
- [ ] Add rate limiting (implemented in server.js)
- [ ] Validate all API inputs
- [ ] Set Content Security Policy headers
- [ ] Enable HSTS
- [ ] Add X-Frame-Options: DENY
- [ ] Add X-Content-Type-Options: nosniff

---

## 📱 PWA Configuration (Optional Enhancement)

Create `manifest.json`:
```json
{
  "name": "FinanceTools Pro",
  "short_name": "FinanceTools",
  "start_url": "/",
  "display": "standalone",
  "background_color": "#ffffff",
  "theme_color": "#2563eb",
  "icons": [
    { "src": "/icon-192.png", "sizes": "192x192" },
    { "src": "/icon-512.png", "sizes": "512x512" }
  ]
}
```

---

## 🔄 Maintenance

### Weekly
- Check Google Search Console for crawl errors
- Monitor Core Web Vitals
- Review AdSense performance reports

### Monthly
- Update blog with 1-2 new posts
- Check for broken links
- Review and update calculator formulas
- Monitor server logs for errors

### Quarterly
- SEO audit with SEMrush/Ahrefs
- Update structured data if needed
- Refresh content on top pages
- Review ad placement performance

---

## 🆘 Troubleshooting

### AdSense ads not showing?
1. Domain must be approved by AdSense (takes 1-2 weeks)
2. Check `ads.txt` file exists with: `google.com, pub-XXXXXXXXXXXXXXXX, DIRECT, f08c47fec0942fa0`
3. Ensure no ad blockers are active
4. Wait 48 hours after placing code

### AI Chat not working?
1. Check `DEEPSEEK_API_KEY` is set in `.env`
2. Verify server is running: `curl http://localhost:3000/api/health`
3. Check browser console for CORS errors
4. Verify `ALLOWED_ORIGINS` includes your domain

### SEO issues?
1. Test with Google Rich Results Test
2. Check mobile-friendliness
3. Verify noindex tags aren't present
4. Ensure JavaScript renders correctly (use URL Inspection tool)

---

## 📞 Support

For issues or questions:
- Check server logs: `pm2 logs financetools`
- Test API: `curl -X POST http://localhost:3000/api/chat -H "Content-Type: application/json" -d '{"message":"test"}'`
- Review AdSense Help Center: https://support.google.com/adsense

---

**Ready to deploy! 🚀**
