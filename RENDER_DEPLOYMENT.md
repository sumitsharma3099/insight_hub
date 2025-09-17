# 🚀 Render Deployment - Step by Step

## Method 1: Manual Deployment (Recommended)

### Step 1: Create Web Service
1. Go to [Render Dashboard](https://dashboard.render.com)
2. Click "New +" → "Web Service"
3. Connect your GitHub repository
4. Select your repository

### Step 2: Configure Web Service
- **Name**: `insight-hub`
- **Environment**: `Ruby`
- **Plan**: `Free`
- **Build Command**: `bundle install && bundle exec rails assets:precompile && bundle exec rails db:migrate`
- **Start Command**: `bundle exec puma -C config/puma.rb`

### Step 3: Add Environment Variables
```
RAILS_MASTER_KEY=d783b9216dce3f07725129d675c88801
RAILS_ENV=production
MEDIASTACK_API_KEY=266cb18a9dd4981a0f3f2491db8a5240
```

### Step 4: Create Database
1. Click "New +" → "PostgreSQL"
2. Name: `insight-hub-db`
3. Plan: `Free`
4. Connect to your web service

### Step 5: Deploy
1. Click "Create Web Service"
2. Wait for deployment (5-10 minutes)
3. Check logs for any errors

## Method 2: Blueprint Deployment

### Step 1: Use render-minimal.yaml
1. Go to [Render Dashboard](https://dashboard.render.com)
2. Click "New +" → "Blueprint"
3. Connect your GitHub repository
4. Select your repository
5. Use `render-minimal.yaml`

### Step 2: Set Environment Variables
```
RAILS_MASTER_KEY=d783b9216dce3f07725129d675c88801
RAILS_ENV=production
MEDIASTACK_API_KEY=266cb18a9dd4981a0f3f2491db8a5240
```

## 🔍 Troubleshooting

### Common Errors:

1. **Build Command Failed**
   - Check if all gems are in Gemfile
   - Verify Ruby version compatibility

2. **Database Connection Error**
   - Ensure DATABASE_URL is set automatically
   - Check PostgreSQL service is running

3. **Asset Compilation Error**
   - Check if Tailwind CSS is properly configured
   - Verify asset pipeline settings

4. **Environment Variable Error**
   - Ensure RAILS_MASTER_KEY is set
   - Check all required variables are present

### Debug Steps:
1. Check build logs in Render dashboard
2. Verify environment variables are set
3. Test locally first: `rails server`
4. Check database connection

## 📊 Expected Services:
- Web Service (Rails app)
- PostgreSQL Database
- (Optional) Worker Service for background jobs

## 🎯 Success Indicators:
- Build completes without errors
- Web service starts successfully
- Database migrations run
- App is accessible via URL
- News data loads (after first worker run)
