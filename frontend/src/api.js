import axios from 'axios';

const API_BASE_URL = '/api';
const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

export const getItems = async () => {
  const response = await api.get('/items');
  return response.data;
};

export const getItemsByCategory = async (category) => {
  const response = await api.get(`/items/${category}`);
  return response.data;
};

export const getRecipes = async () => {
  const response = await api.get('/recipes');
  return response.data;
};

export const getRecipeForItem = async (itemName) => {
  const response = await apt.get(`/recipes/${itemName}`);
  return response.data;
};

export const calculateProduction = async (itemName, targetRate) => {
  const response = await api.post('/calculate', {
    item_name: itemName,
    target_rate: targetRate,
  });
  return response.data;
};

export const checkHealth = async () => {
  const response = await api.get('/health');
  return response.data;
};

export default api;
