import { useState } from 'react';
import ItemList from './components/ItemList';
import './App.css';

function App() {
  return (
    <>
      <div className="App">
        <header className="App-header">
          <h1>Satisfactory Production Calculator</h1>
          <p>For efficient factory planning</p>
        </header>
        
        <main>
          <ItemList />
        </main>
      </div>
    </>
  );
}

export default App;
