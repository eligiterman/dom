document.getElementById('load').addEventListener('click', async () => {
    const res = await fetch('http://localhost:4000/data');
    const data = await res.json();
    document.getElementById('output').textContent = JSON.stringify(data, null, 2);
  });
  