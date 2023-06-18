<script lang='ts'>
  import { onMount } from 'svelte';
  import { Select, Label, Spinner, Input, Button } from 'flowbite-svelte';
  import type {  AspectData, OwnedAspects } from './lib/types';
  import Aspect from './lib/Aspect.svelte';

  let classes = [
    { value: "", name: "All Classes" },
    { value: "Barbarian", name: "Barbarian" },
    { value: "Druid", name: "Druid" },
    { value: "Necromancer", name: "Necromancer" },
    { value: "Rogue", name: "Rogue" },
    { value: "Sorcerer", name: "Sorcerer" },
  ];

  let aspects = [];
  let selectedClass = '';
  let searchTerm = '';
  let limitToOwned = false;

  let ownedAspects: OwnedAspects = {};

  async function getAspects() {
    const aspects_db_url = '/aspects.json';

    try {
      const response = await fetch(aspects_db_url);

      if (!response.ok) {
        throw new Error(`HTTP error! Status: ${response.status}`);
      }

      const data: AspectData = await response.json();

      // Check if the response is valid JSON
      if (typeof data !== 'object') {
        throw new Error('Invalid JSON format!');
      }

      aspects = Object.entries(data).map(([name, aspect]) => ({ name: name, ...aspect }));
    } catch (error) {
      console.error(error);
    }
  }

  // Load owned aspects from local storage on component mount
  onMount(() => {
    getAspects();
    // example ownedAspects
    // {
    //   "Abyssal": [{
    //     "note": "25%",
    //     "time": "2021-05-01T12:00:00"
    //   }, {
    //     "note": "50%",
    //     "time": "2021-05-02T12:00:00"
    //   }]
    // }
    const ownedAspectsData = localStorage.getItem('ownedAspects');
    if (ownedAspectsData) {
      ownedAspects = JSON.parse(ownedAspectsData);
    }
  });

    // Function to handle the event when a new aspect is added
    function handleAspectAdded() {
      // Update the local data or trigger a refresh
      console.log("handle event")
      const ownedAspectsData = localStorage.getItem('ownedAspects');
      if (ownedAspectsData) {
        ownedAspects = JSON.parse(ownedAspectsData);
      }
    }

  $: filteredAspects = aspects.filter((aspect) => {
    if (selectedClass === '') {
      return true;
    } else if (selectedClass === 'All Classes') {
      return true;
    } else {
      return aspect.class === selectedClass || aspect.class === 'Generic';
    }
  }).filter((aspect) => {
    return aspect.name.toLowerCase().includes(searchTerm.toLowerCase());
  })  .filter((aspect) => {
    if (limitToOwned) {
      return !!ownedAspects[aspect.name];
    }
    return true;
  });
</script>

<div class="p-8">
  <Label>Select a class</Label>
  <Select class="mt-2" items={classes} bind:value={selectedClass} />

  <Label>Search by aspect name</Label>
  <Input bind:value={searchTerm} placeholder="Enter search term" class="mt-2" />

  <Label>Limit to owned</Label>
  <input type="checkbox" bind:checked={limitToOwned} />

  <h2>Aspects</h2>
  {#if aspects.length > 0}
    {#each filteredAspects as aspect}
      <Aspect
        aspect={aspect}
        ownedList={ownedAspects[aspect.name] || []}
        on:aspectAdded={handleAspectAdded}
      />
    {/each}
  {:else}
    <Spinner />
  {/if}
</div>
