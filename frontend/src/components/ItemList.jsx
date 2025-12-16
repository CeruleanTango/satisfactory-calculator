import { useState, useEffect } from 'react';
import { getItems } from '../api';
import './ItemList.css';

function ItemList() {
  const [items, setItems] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [filter, setFilter] = useState('all');

  useEffect(() => {
    fetchItems();
  }, []);

  const fetchItems = async () => {
    try {
      setLoading(true);
      setError(null);
      const data = await getItems();
      setItems(data.items);
    } catch (err) {
      setError('Failed to fetch items: ' + err.message);
      console.error('Error fetching items: ', err);
    } finally {
      setLoading (false);
    }
  };

  const filteredItems = filter === 'all'
    ? items
    : items.filter(item => item.category === filter);

  if (loading) {
    return <div className="loading">Loading items...</div>;
  }

  if (error) {
    return <div className="error">{error}</div>;
  }

  return (
    <div className="item-list">
      <h2> Items ({filteredItems.length})</h2>

      <div className="filters">
        <button
          className={filter === 'all' ? 'active' : ''}
          onClick={() => setFilter('all')}
        > 
          All ({items.length})
        </button>

        <button
          className={filter === 'raw' ? 'active' : ''}
          onClick={() => setFilter('raw')}
        >
          Raw ({items.filter(i => i.category === 'raw').length})
        </button>

        <button
          className={filter === 'intermediate' ? 'active' : ''}
          onClick={() => setFilter('intermediate')}
        >
          Intermediate ({items.filter(i => i.category === 'intermediate').length})
        </button>
      </div>

      <div className = "items-grid">
        {filteredItems.map((item, index) => (
          <div key={index} className = "item-card">
            <div className="item-name">{item.name}</div>
            <div className={`item-category ${item.category}`}>
              {item.category}
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

export default ItemList;
  
          
