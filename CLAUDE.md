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

This is a Jekyll static site with a custom theme (no gem-based theme), deployed on DigitalOcean App Platform.

**Typography:**
- Inter (Google Fonts) for all UI elements: site name, navigation, post titles, dates, labels, pagination, footer
- Lora (Google Fonts, serif) for reading text: post body content, excerpts, page content

**Layout:**
- Single column, max-width 720px, centered. No sidebar.
- Colors: #ffffff background, #1a1a1a text, #924a28 terracotta accent (hover states only)
- Design rules: No 1px border dividers, 4px border radius only, no drop shadows, no hero sections, no sticky nav

**Layouts:**
- `_layouts/default.html` - Base HTML shell with Google Fonts, CSS, header/footer includes
- `_layouts/home.html` - Homepage with directory grid + paginated posts (5 per page via jekyll-paginate)
- `_layouts/post.html` - Single blog post with title, date, optional hero image, body content
- `_layouts/page.html` - Generic page layout (title + content)
- `_layouts/single.html` - Alias for page layout (used by recipes collection)
- Section-specific layouts extending page: radio, recipes, bookmarks, books, bicycle, instruments, edc, now, about, contact
- `_layouts/recipes.html` - Lists the recipes collection after page content

**Includes:**
- `_includes/header.html` - Site name as a plain text link
- `_includes/footer.html` - Social links and copyright line
- `_includes/directory.html` - 3-column grid of underlined section links (2 columns on mobile)

**Content Organization:**
- Posts in `_posts/` - blog posts with optional `image` front matter field for hero images
- Pages in `_pages/` - first-class section pages (Radio, Recipes, Bookmarks, Books, Bicycle, Instruments & Audio, EDC, Now, About, Contact)
- Recipes collection in `_recipes/` with output enabled
- Directory links configured in `_data/navigation.yml`
- Social links configured in `_config.yml` under `social_links`

**Key Configuration:**
- Pagination: 5 posts per page via jekyll-paginate
- No categories or tags archive pages
- No comments system

**Deployment:**
- DigitalOcean App Platform via `.do/app.yaml`
- Builds with `bundle exec jekyll build -d ./public`
- Auto-deploys from main branch
- Static files in `public/` directory excluded from Jekyll processing via `_config.yml`

**Content Guidelines:**
- Post filename format: `YYYY-MM-DD-title.md`
- Front matter requires: title, date, categories
- Optional front matter: `image` (path to hero image, displayed at 16:9 aspect ratio)
- Uses `####` for post subheadings (not `##`)
- Avoid em dashes in content
