<script lang='ts'>
  import { onMount } from 'svelte';
  import { Select, Label, Spinner, Input, Button, Card, Checkbox } from 'flowbite-svelte';
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
  let notInCodex = false;

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
    function handleAspectUpdated() {
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
  }).filter((aspect) => {
    if (notInCodex) {
      return !aspect.in_codex;
    }
    return true;
  }).filter((aspect) => {
    if (limitToOwned) {
      return !!ownedAspects[aspect.name];
    }
    return true;
  });
</script>

<div class="w-96">
  <Card class="flex">
    <h1>
      D4 Aspect Tracker
    </h1>
    <div class="mr-4">
      <Input bind:value={searchTerm} placeholder="Search by aspect name" class="mt-2" />
    </div>
    <div class="mr-4">
      <Select placeholder="Select a class" class="mt-2" items={classes} bind:value={selectedClass} />
    </div>
    <div class="mr-4 mt-2" >
      <Checkbox bind:checked={limitToOwned}> Limit to owned </Checkbox>
      <Checkbox bind:checked={notInCodex}> Not in codex </Checkbox>
    </div>
  </Card>

  <div class="aspect-container mt-8">
    {#if aspects.length > 0}
      {#each filteredAspects as aspect}
        <Aspect
          aspect={aspect}
          ownedList={ownedAspects[aspect.name] || []}
          on:aspectUpdated={handleAspectUpdated}
        />
      {/each}
    {:else}
      <Spinner />
    {/if}
  </div>
</div>


<style>
  .aspect-container {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
    gap: 1rem;
  }
</style>