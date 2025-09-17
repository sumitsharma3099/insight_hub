# Insight Hub - Render Deployment Guide

## 🚀 Deploy to Render

This guide will help you deploy your Insight Hub news terminal to Render platform.

### Prerequisites
- GitHub repository with your code
- Render account (free tier available)
- MediaStack API key

### Step 1: Prepare Your Repository

Your repository should include:
- ✅ `render.yaml` - Render configuration
- ✅ `bin/render-build.sh` - Build script
- ✅ Updated `Gemfile` with PostgreSQL
- ✅ Updated `config/database.yml` for production
- ✅ Updated `config/sidekiq.yml` for Redis

### Step 2: Create Render Services

1. **Go to [Render Dashboard](https://dashboard.render.com)**
2. **Click "New +" → "Blueprint"**
3. **Connect your GitHub repository**
4. **Select your repository**

### Step 3: Configure Environment Variables

In Render dashboard, add these environment variables:

#### Required Variables:
```
RAILS_MASTER_KEY=your_rails_master_key_here
MEDIASTACK_API_KEY=266cb18a9dd4981a0f3f2491db8a5240
RAILS_ENV=production
```

#### Optional Variables:
```
RAILS_MAX_THREADS=5
```

### Step 4: Deploy

1. **Click "Apply"** in Render dashboard
2. **Wait for deployment** (5-10 minutes)
3. **Check logs** for any errors

### Step 5: Verify Deployment

1. **Visit your app URL** (provided by Render)
2. **Check if news are loading**
3. **Verify SEO meta tags** in page source
4. **Test background workers** (news should update every 8 hours)

### Step 6: Monitor Your App

- **Logs**: Check Render dashboard for application logs
- **Metrics**: Monitor CPU, memory, and response times
- **Database**: Check PostgreSQL database in Render dashboard
- **Redis**: Monitor Redis instance for Sidekiq jobs

## 🔧 Troubleshooting

### Common Issues:

1. **Build Fails**
   - Check `bin/render-build.sh` permissions
   - Verify all gems are in Gemfile
   - Check Rails master key is set

2. **Database Connection Issues**
   - Verify DATABASE_URL is set automatically
   - Check PostgreSQL service is running

3. **Sidekiq Not Working**
   - Verify REDIS_URL is set automatically
   - Check worker service is running
   - Look for job processing in logs

4. **News Not Loading**
   - Check MediaStack API key
   - Verify network connectivity
   - Check worker logs for errors

### Logs to Check:
```bash
# In Render dashboard, check these logs:
- Web service logs
- Worker service logs
- Database logs
- Redis logs
```

## 📊 Services Created

Your deployment will create:

1. **Web Service** - Main Rails application
2. **Worker Service** - Background job processing (Sidekiq)
3. **PostgreSQL Database** - Production database
4. **Redis Instance** - Job queue storage

## 🔄 Automatic Updates

- **News Update**: Every 8 hours via scheduled job
- **SEO Update**: Automatically after news update
- **Database Migrations**: Run during deployment

## 💰 Cost

- **Free Tier**: Includes all services for small apps
- **Paid Plans**: Available for higher traffic and features

## 🆘 Support

If you encounter issues:
1. Check Render documentation
2. Review application logs
3. Verify environment variables
4. Test locally first

Your Insight Hub should be live and running automatically! 🎉
