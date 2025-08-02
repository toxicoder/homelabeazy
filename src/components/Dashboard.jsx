// file: components/Dashboard.js
import React, { useState, useEffect } from 'react';
import { getData, postData } from '../utils/api';

const Dashboard = () => {
  // 1. Use useState for state management
  const [userData, setUserData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  // 2. Use useEffect to fetch data on component mount
  useEffect(() => {
    const fetchInitialData = async () => {
      try {
        const data = await getData('user/profile');
        setUserData(data);
      } catch (err) {
        setError('Failed to fetch user profile. Please try again later.');
      } finally {
        setLoading(false);
      }
    };

    fetchInitialData();
  }, []); // Empty dependency array ensures this runs only once on mount

  // 3. Rewrite handler as an async function
  const handleUpdate = async () => {
    const newNameData = { name: 'New Name' };
    try {
      // Optimistically update UI or show loading state if preferred
      const updatedProfile = await postData('user/profile', newNameData);
      setUserData(updatedProfile);
      console.log('Update successful');
    } catch (err) {
      // Provide user feedback on failure
      alert('Failed to update name. Please try again.');
      console.error('Update failed', err);
    }
  };

  // 4. Conditional rendering based on state
  if (loading) return <div>Loading...</div>;
  if (error) return <div>Error: {error}</div>;

  return (
    <div>
      <h1>Welcome, {userData ? userData.name : 'User'}</h1>
      <button onClick={handleUpdate}>Update Name</button>
    </div>
  );
};

export default Dashboard;
