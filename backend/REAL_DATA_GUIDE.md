# 🏠 Real Data Integration Guide

This guide will walk you through testing and using real data from your RapidAPI subscriptions.

## 🎯 What We'll Do

1. **Test API Connections** - See if your subscriptions are working
2. **Fetch Real Data** - Pull actual listings from APIs
3. **Save to Database** - Store real data for your application
4. **Troubleshoot Issues** - Handle common problems

## 📋 Prerequisites

- ✅ RapidAPI account with active subscriptions
- ✅ API key configured in `.env` file
- ✅ Ruby and dependencies installed

## 🚀 Step-by-Step Process

### Step 1: Check Your Setup

First, make sure you're in the backend directory and your environment is ready:

```bash
cd backend
bundle install
```

### Step 2: Test API Connections

Let's see if your APIs are responding:

```bash
# Option A: Use the interactive test script
ruby test_real_data.rb

# Option B: Use Rake task
rake test_apis
```

**What to expect:**
- ✅ **healthy** = API is working perfectly
- ⚠️ **error** = API responded but with an error (subscription might not be active yet)
- ❌ **unavailable** = Connection failed (check internet/API key)

### Step 3: Fetch Real Data

If your connections are working, let's fetch real data:

```bash
# Option A: Interactive script (recommended for first time)
ruby test_real_data.rb

# Option B: Rake task
rake fetch_real_data
```

### Step 4: Save to Database

Once you have real data, save it to your database:

```bash
# Option A: Interactive script will ask you
ruby test_real_data.rb

# Option B: Rake task
rake save_real_data
```

### Step 5: View Your Data

Start your server and view the real data:

```bash
bundle exec ruby app.rb
```

Then visit: http://localhost:4000/listings

## 🔧 Useful Commands

```bash
# Test API connections only
rake test_apis

# Fetch real data (without saving)
rake fetch_real_data

# Fetch and save real data
rake save_real_data

# Clear all real data from database
rake clear_real_data

# Show database statistics
rake stats

# Reset to sample data
rake reset_sample
```

## 🚨 Troubleshooting

### "API Key Not Configured"
```bash
# Edit your .env file
cp env.example .env
# Then edit .env and add your RapidAPI key
```

### "No Data Returned"
This usually means:
- **Subscriptions not active yet** - Wait a few hours after subscribing
- **No properties match criteria** - Try different cities/states
- **Rate limit reached** - Wait and try again later

### "Connection Failed"
- Check your internet connection
- Verify your API key is correct
- Make sure you're subscribed to the APIs

### "Database Errors"
```bash
# Reset your database
rake db:drop
rake db:create
rake db:migrate
rake db:seed
```

## 📊 Understanding the Data Flow

```
1. API Request → 2. Parse Response → 3. Transform Data → 4. Save to Database
```

**Key Learning Points:**
- **API Request**: We send HTTP requests with your key
- **Parse Response**: Convert JSON to Ruby objects
- **Transform Data**: Map API fields to our database structure
- **Save to Database**: Store for your application to use

## 🎓 What You're Learning

1. **API Integration**: How to connect to external services
2. **Data Transformation**: Converting between different data formats
3. **Error Handling**: Gracefully dealing with failures
4. **Database Operations**: Storing and retrieving data
5. **Testing**: Verifying your code works before using it

## 💡 Pro Tips

- **Start with testing**: Always test connections before fetching data
- **Check logs**: The scripts show detailed information about what's happening
- **Be patient**: API subscriptions can take time to activate
- **Use sample data**: Keep sample data for development when APIs are down

## 🔄 Next Steps

Once you have real data working:
1. **Customize search criteria** in `config/api_config.rb`
2. **Add more APIs** to expand your data sources
3. **Build your frontend** to display the real data
4. **Add caching** to reduce API calls

---

**Remember**: This is a learning process! Don't worry if things don't work perfectly the first time. Each error teaches you something new about how APIs and web services work. 