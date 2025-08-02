// file: utils/api.js
import axios from 'axios';

// 1. Create a centralized Axios instance
const apiClient = axios.create({
  baseURL: 'https://api.example.com',
});

// 2. Rewrite as an async function with camelCase naming
export const getData = async (endpoint) => {
  try {
    const response = await apiClient.get(endpoint);
    return response.data;
  } catch (error) {
    console.error('API GET Error:', error);
    // Re-throw the error so the calling component can handle it
    throw error;
  }
};

// 3. Rewrite as an async function
export const postData = async (endpoint, data) => {
  try {
    const response = await apiClient.post(endpoint, data);
    return response.data;
  } catch (error) {
    console.error('API POST Error:', error);
    throw error;
  }
};
