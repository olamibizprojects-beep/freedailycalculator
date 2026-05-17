# Free Daily Calculator

**Live Site:** https://freedailycalculator.com

A comprehensive, SEO-optimized financial calculator web application featuring 75+ free calculators, 100+ blog articles, AI-powered financial assistant, and AdSense-ready ad placements.

## Features

- **75+ Financial Calculators** — Loans, mortgages, investments, taxes, budgeting, business
- **100 SEO Blog Posts** — Long-tail keyword optimized articles with category filtering
- **AI Financial Assistant** — DeepSeek AI integration (requires backend proxy)
- **Dark Mode & Mobile Responsive**
- **PDF Export & Print Support**
- **Charts & Visualizations** (Chart.js)
- **AdSense Ready** — 4 placeholder ad slots compliant with Google policies

## Tech Stack

- Frontend: HTML5, Tailwind CSS (CDN), Chart.js, jsPDF
- Backend: Node.js, Express (for AI chat proxy)
- Deployment: Static hosting (Netlify/Vercel/Cloudflare Pages)

## Quick Deploy

### Option 1: Netlify (Easiest)
1. Go to https://app.netlify.com/drop
2. Drag this folder onto the page
3. Add custom domain: freedailycalculator.com

### Option 2: Vercel (Full Stack + AI)
```bash
npm install -g vercel
vercel --prod
```

### Option 3: GitHub Pages
1. Push to GitHub repository
2. Enable Pages in repository settings
3. Select "Deploy from branch" → main → root

## SEO Optimizations

- JSON-LD Structured Data (WebApplication, Organization, BreadcrumbList)
- Semantic HTML5 with proper heading hierarchy
- Sitemap.xml with 50+ URLs
- Robots.txt configured
- Open Graph & Twitter Cards
- Mobile-first responsive design
- Preconnect hints for performance

## Legal Pages (AdSense Compliant)

- Privacy Policy
- Terms of Service
- Disclaimer
- Cookie Policy

## Environment Variables (for AI Chat)

Create `.env` file:
```
DEEPSEEK_API_KEY=your_key_here
ALLOWED_ORIGINS=https://freedailycalculator.com
PORT=3000
```

## License

MIT License — Free for personal and commercial use.
