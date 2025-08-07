# Development Branch

This repository now includes a `dev` branch for ongoing development work.

## Branch Structure

- `main` - Stable production-ready code
- `dev` - Development branch for ongoing feature work and testing

## Development Workflow

1. Create feature branches from `dev`
2. Merge completed features back to `dev`
3. Periodically merge `dev` to `main` for releases

The CI/CD pipeline (GitHub Actions) will automatically build and test all branches including the new `dev` branch.