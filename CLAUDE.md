# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

**Local Development:**
- `bundle exec jekyll serve` - Start the development server (requires restart after _config.yml changes)
- `bundle install` - Install dependencies
- `bundle update jekyll` - Update Jekyll version

**Dependencies:**
- Ruby 3.3.7
- Jekyll 4.4.1
- CSV gem (required for Ruby 3+ compatibility)

## Site Architecture

This is a Jekyll static site using the **Minimal Mistakes** theme, deployed on DigitalOcean App Platform.

**Theme Customizations:**
- Custom `_layouts/home.html` - Removes "Recent Posts" heading from index
- Custom `_includes/archive-single.html` - Extends excerpt length to 500 chars and adds "Read more →" links
- Custom `_includes/social-share.html` - Removes Twitter/X, keeps Facebook, LinkedIn, and Bluesky
- Custom CSS in `assets/css/main.scss` - Reduces font size and fixes homepage spacing issues

**Content Organization:**
- Posts in `_posts/` with categories: general, radio, recipes, update
- Static pages in `_pages/` for Categories and Tags archives
- Navigation configured in `_data/navigation.yml`

**Key Configuration:**
- Comments disabled (giscus config commented out)
- Social sharing enabled but no Twitter/X
- Jekyll Archives plugin generates category/tag pages
- Excerpt truncation customized to 500 characters

**Deployment:**
- DigitalOcean App Platform via `.do/app.yaml`
- Builds with `bundle exec jekyll build -d ./public`
- Auto-deploys from main branch
- Static files in `public/` directory excluded from Jekyll processing via `_config.yml`

**Content Guidelines:**
- Post filename format: `YYYY-MM-DD-title.md`
- Front matter requires: title, date, categories
- Uses `####` for post subheadings (not `##`)
- Avoid em dashes in content
