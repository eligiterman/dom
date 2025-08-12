# 🧪 Test Scripts

This directory contains utility scripts for testing and debugging the Real Estate API.

## 📋 Available Scripts

### `test_all_apis.rb`
**Purpose**: Comprehensive test of all configured RapidAPI endpoints
**Usage**: `ruby scripts/test_all_apis.rb`
**What it does**: Tests connectivity and data reception from all APIs in your configuration

### `quick_api_test.rb`
**Purpose**: Quick test of a specific API endpoint
**Usage**: `ruby scripts/quick_api_test.rb`
**What it does**: Interactive script to test individual API connections

### `test_real_data.rb`
**Purpose**: Test real data fetching and database operations
**Usage**: `ruby scripts/test_real_data.rb`
**What it does**: Fetches real data from APIs and optionally saves to database

## 🚀 Running Scripts

From the `backend` directory:

```bash
# Test all APIs
ruby scripts/test_all_apis.rb

# Quick API test
ruby scripts/quick_api_test.rb

# Test real data
ruby scripts/test_real_data.rb
```

## 📊 What to Expect

- **Green checkmarks** ✅ = API working correctly
- **Red X marks** ❌ = API issues (check subscription/credentials)
- **Detailed error messages** for troubleshooting

## 🔧 Troubleshooting

If scripts fail:
1. Check your `.env` file has `RAPIDAPI_KEY`
2. Verify API subscriptions on RapidAPI
3. Check internet connection
4. Review error messages for specific issues

## 📈 Usage Notes

- These scripts use your API calls, so run sparingly
- Use for testing before deploying to production
- Results help identify which APIs are working
