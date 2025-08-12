# 🚀 Deployment Guide - Real Estate Data Viewer

## 🎯 Quick Deploy to Render (Recommended)

### Step 1: Prepare Your Repository
1. Make sure all your code is committed to GitHub
2. Ensure your `.env` file is in `.gitignore` (it should be)

### Step 2: Deploy to Render
1. **Go to [render.com](https://render.com)** and sign up/login
2. **Click "New +"** → **"Web Service"**
3. **Connect your GitHub repository**
4. **Configure the service:**
   - **Name**: `real-estate-viewer`
   - **Environment**: `Ruby`
   - **Build Command**: `bundle install`
   - **Start Command**: `bundle exec ruby config.ru`
   - **Root Directory**: `backend`

### Step 3: Set Environment Variables
In Render dashboard, go to **Environment** tab and add:
- `RAPIDAPI_KEY` = Your actual RapidAPI key
- `ENVIRONMENT` = `production`

### Step 4: Deploy!
Click **"Create Web Service"** and wait for deployment.

## 🌐 Access Your Deployed App

Once deployed, you'll get a URL like: `https://your-app-name.onrender.com`

- **API Endpoints**: `https://your-app-name.onrender.com/`
- **Data Viewer**: `https://your-app-name.onrender.com/viewer`

## 🔧 Alternative: Railway Deployment

### Step 1: Deploy to Railway
1. Go to [railway.app](https://railway.app)
2. Connect your GitHub repo
3. Set environment variables
4. Deploy!

## 🛠️ Local Development (Alternative)

If you prefer to run locally:

### Backend Only:
```bash
cd backend
bundle install
bundle exec ruby config.ru
```

### Frontend Only:
```bash
cd frontend
python -m http.server 8080
```

Then visit: `http://localhost:8080/data_viewer.html`

## 🔍 Testing Your Deployment

1. **Test API**: Visit your deployed URL (e.g., `https://your-app.onrender.com/`)
2. **Test Data Viewer**: Visit `/viewer` endpoint
3. **Click "Fetch All Data"** to test your APIs

## 🚨 Troubleshooting

### Common Issues:
- **CORS Errors**: The deployed version should handle this automatically
- **API Key Issues**: Make sure `RAPIDAPI_KEY` is set in environment variables
- **Database Issues**: The app will work without a database for viewing API data

### Environment Variables:
Make sure these are set in your deployment platform:
- `RAPIDAPI_KEY` = Your RapidAPI key
- `ENVIRONMENT` = `production`

## 📊 What You'll See

Once deployed, you can:
- View real estate data from all your APIs
- See complete data structures
- Export data as JSON
- Share the URL with others

## 🎉 Success!

Your Real Estate Data Viewer will be live and accessible from anywhere! 