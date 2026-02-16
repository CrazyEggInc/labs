# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This repository contains Optimizely Labs - a collection of self-contained tutorials demonstrating how to work with Optimizely data and developer tools. Each lab is published to optimizely.com/labs via a Contentful CMS integration.

## Repository Architecture

### Content Structure
- **`/labs/`**: Each subdirectory is a self-contained lab with its own README.md (tutorial content), metadata.md (Contentful metadata), and any supporting code/resources
- **`/utils/`**: Python scripts for publishing and managing labs in Contentful CMS
- **`/templates/`**: Templates for creating new labs (new-content and link-to-existing-content)
- **`.github/workflows/`**: CI/CD pipelines for automatic publishing to Contentful

### Lab Publication System
The repository uses a Python-based publishing system that:
1. Scans `/labs/` for all lab directories (slugs)
2. Zips each lab's contents and uploads to S3
3. Parses `metadata.md` (YAML frontmatter) and README.md/index.md
4. Upserts lab entries to Contentful CMS
5. Labs appear at `optimizely.com/labs/{slug}`

**Key files:**
- `utils/publish.py`: Main publishing script - zips labs, uploads to S3, syncs to Contentful
- `utils/delete.py`: Deletes a specific lab from Contentful
- `utils/labs_constants.py`: Configuration constants (paths, Contentful settings, S3 credentials)

### Lab Slug Requirements
- Slugs must match `^[a-zA-Z0-9-.]{1,64}$` (alphanumeric, dashes, periods, underscores only)
- Slugs serve as both directory names and Contentful entry IDs
- Slugs become URL paths: `optimizely.com/labs/{slug}`

## Common Development Tasks

### Installing Dependencies
```bash
pip install -r requirements.txt
```

### Publishing Labs to Contentful
Publishing happens automatically on push to `master` branch via GitHub Actions, but can be run manually:

```bash
# Set required environment variables (see labs_constants.py for full list)
export LABS_CONTENTFUL_ENVIRONMENT=master
export LABS_CONTENTFUL_SPACE_ID=zw48pl1isxmc
export LABS_CONTENTFUL_MANAGEMENT_API_TOKEN=<token>
export LIBRARY_URL=https://library.optimizely.com/
export LIBRARY_S3_BUCKET=library-optimizely-com
export LIBRARY_S3_ACCESS_KEY=<key>
export LIBRARY_S3_SECRET_KEY=<secret>

# Run publish script
python utils/publish.py
```

### Deleting a Lab
```bash
export SLUG_TO_DELETE=<lab-slug>
export LABS_CONTENTFUL_ENVIRONMENT=master
export LABS_CONTENTFUL_SPACE_ID=zw48pl1isxmc
export LABS_CONTENTFUL_MANAGEMENT_API_TOKEN=<token>

python utils/delete.py
```

### Creating a New Lab

1. Create directory under `/labs/` with a valid slug name
2. Add `README.md` using template from `/templates/new-content/README.md` or `/templates/link-to-existing-content/README.md`
3. Add `metadata.md` using template from `/templates/metadata.md`
4. Set `excludeFromListing: true` in metadata.md initially
5. Use absolute URLs for links/images (prefix with `https://raw.githubusercontent.com/optimizely/labs/master/` for images)
6. Submit PR for review
7. After merge, lab appears at `optimizely.com/labs/{slug}`
8. When ready to feature, set `excludeFromListing: false` via separate PR

### Lab Content Structure

**README.md/index.md** (content priority: index.md > README.md):
- Tutorial content in Markdown
- Should include: summary, pre-requisites, numbered steps
- Use absolute URLs for all links and images

**metadata.md**:
- YAML frontmatter with: title, summary, revisionDate, labels, author, seo, excludeFromListing
- Controls how lab appears in Contentful and on optimizely.com/labs

## Lab Types

Labs cover various Optimizely integrations and use cases:
- **Feature Flags**: Python Flask, Ruby Sinatra examples
- **Data Analysis**: Spark/PySpark notebooks for Enriched Event data
- **Integrations**: Third-party integrations (ContentSquare, Crazy Egg, Zuko, Segment)
- **Browser Extensions**: Custom Optimizely editor extensions
- **Event Targeting**: Sequential events, custom targeting examples

### Data Analysis Labs
Some labs (computing-experiment-metrics, query-enriched-event-data-with-spark) use:
- Docker for containerized execution
- PySpark for processing Optimizely Enriched Event data
- Jupyter Lab for interactive notebooks
- Python requirements.txt for lab-specific dependencies

Run these labs using:
```bash
bash bin/run.sh           # Uses Docker (primary method)
bash bin/run-docker.sh    # Direct Docker execution
```

## Important Notes

- Labs are self-contained - all resources should be within the lab directory
- Publishing is automatic on master branch commits
- Lab zips are uploaded to S3 and linked in Contentful as downloadable resources
- Metadata field `excludeFromListing: true` hides labs from main listing page
- Use GitHub Actions workflow "Contentful Delete" to manually delete labs
