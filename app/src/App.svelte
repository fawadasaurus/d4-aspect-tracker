<script lang="ts">
  import { onMount } from 'svelte'
  import { Banner, Select, Spinner, Input, Checkbox } from 'flowbite-svelte'
  import type { AspectData, OwnedAspects } from './lib/types'
  import Aspect from './lib/Aspect.svelte'

  let classes = [
    { value: '', name: 'All Classes' },
    { value: 'Barbarian', name: 'Barbarian' },
    { value: 'Druid', name: 'Druid' },
    { value: 'Necromancer', name: 'Necromancer' },
    { value: 'Rogue', name: 'Rogue' },
    { value: 'Sorcerer', name: 'Sorcerer' },
  ]

  let codex = [
    { value: '', name: 'All Aspects' },
    { value: 'true', name: 'In Codex' },
    { value: 'false', name: 'Not In Codex' },
  ]

  // "Defensive": "Amulet [+50%], Chest, Helmet, Pants, Shield.",
  // 	"Offensive": "Amulet [+50%], Gloves, Ring, 1H Weapon, 2H Weapon [+100%].",
  // 	"Utility": "Amulet [+50%], Boots, Chest, Gloves, Helmet, Shield.",
  // 	"Resource": "Ring.",
  // 	"Mobility": "Amulet [+50%], Boots.",

  let slots = [
    { value: '', name: 'All Slots' },
    { value: 'Helmet', name: 'Helmet' },
    { value: 'Chest', name: 'Chest' },
    { value: 'Gloves', name: 'Gloves' },
    { value: 'Pants', name: 'Pants' },
    { value: 'Boots', name: 'Boots' },
    { value: 'Weapon', name: 'Weapon' },
    { value: 'Offhand', name: 'Offhand' },
    { value: 'Amulet', name: 'Amulet' },
    { value: 'Ring', name: 'Ring' },
    { value: 'Shield', name: 'Shield' },
  ]

  let aspects = []
  let selectedClass = ''
  let searchTerm = ''
  let selectedSlot = ''
  let limitToOwned = false
  let selectedCodex = ''

  let ownedAspects: OwnedAspects = {}

  async function getAspects() {
    const aspects_db_url = '/aspects.json'

    try {
      const response = await fetch(aspects_db_url)

      if (!response.ok) {
        throw new Error(`HTTP error! Status: ${response.status}`)
      }

      const data: AspectData = await response.json()

      // Check if the response is valid JSON
      if (typeof data !== 'object') {
        throw new Error('Invalid JSON format!')
      }

      aspects = Object.entries(data).map(([name, aspect]) => ({
        name: name,
        ...aspect,
      }))
    } catch (error) {
      console.error(error)
    }
  }

  function loadOwnedAspectsFromLocalStorage() {
    const loadedOwnedAspects = {}

    for (let i = 0; i < localStorage.length; i++) {
      const key = localStorage.key(i)
      if (key) {
        const values = localStorage.getItem(key)
        if (values) {
          loadedOwnedAspects[key] = JSON.parse(values)
        }
      }
    }

    return loadedOwnedAspects
  }

  // Load owned aspects from local storage on component mount
  onMount(() => {
    getAspects()
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

    // migrate from old storage to new
    const ownedAspectsData = localStorage.getItem('ownedAspects')
    if (ownedAspectsData) {
      ownedAspects = JSON.parse(ownedAspectsData)
      if (ownedAspectsData.length > 0) {
        for (const key in ownedAspects) {
          const values = ownedAspects[key]
          localStorage.setItem(key, JSON.stringify(values))
        }
        localStorage.removeItem('ownedAspects')
      }
    }

    // Load owned aspects from local storage
    ownedAspects = loadOwnedAspectsFromLocalStorage()
  })

  // Function to handle the event when a new aspect is added
  function handleAspectUpdated() {
    // Update the local data or trigger a refresh
    ownedAspects = loadOwnedAspectsFromLocalStorage()
  }

  $: filteredAspects = aspects
    .filter((aspect) => {
      if (selectedClass === '') {
        return true
      } else if (selectedClass === 'All Classes') {
        return true
      } else {
        return aspect.class === selectedClass || aspect.class === 'Generic'
      }
    })
    .filter((aspect) => {
      if (searchTerm === '') {
        return true
      }
      return (
        aspect.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
        aspect.desc.toLowerCase().includes(searchTerm.toLowerCase())
      )
    })
    .filter((aspect) => {
      if (selectedCodex === '') {
        return true
      } else if (selectedCodex === 'false') {
        return !aspect.in_codex
      } else if (selectedCodex === 'true') {
        return aspect.in_codex
      }
    })
    .filter((aspect) => {
      if (limitToOwned) {
        return !!ownedAspects[aspect.name]
      }
      return true
    })
    .filter((aspect) => {
      if (selectedSlot === '') {
        return true
      } else if (selectedSlot === 'Helmet') {
        return aspect.category === 'Defensive' || aspect.category === 'Utility'
      } else if (selectedSlot === 'Chest') {
        return aspect.category === 'Defensive' || aspect.category === 'Utility'
      } else if (selectedSlot === 'Gloves') {
        return aspect.category === 'Offensive' || aspect.category === 'Utility'
      } else if (selectedSlot === 'Pants') {
        return aspect.category === 'Defensive'
      } else if (selectedSlot === 'Boots') {
        return aspect.category === 'Utility' || aspect.category === 'Mobility'
      } else if (selectedSlot === 'Weapon' || aspect.category === 'Offhand') {
        return aspect.category === 'Offensive'
      } else if (selectedSlot === 'Amulet') {
        return (
          aspect.category === 'Defensive' ||
          aspect.category === 'Offensive' ||
          aspect.category === 'Utility' ||
          aspect.category === 'Mobility'
        )
      } else if (selectedSlot === 'Ring') {
        return aspect.category === 'Offensive' || aspect.category === 'Resource'
      } else if (selectedSlot === 'Shield') {
        return aspect.category === 'Defensive' || aspect.category === 'Utility'
      } else {
        return aspect.slot === selectedSlot
      }
    })
    .sort((a, b) => {
      const nameA = a.name.toLowerCase()
      const nameB = b.name.toLowerCase()
      if (nameA < nameB) {
        return -1 // a should come before b in the sorted order
      }
      if (nameA > nameB) {
        return 1 // a should come after b in the sorted order
      }
      return 0 // a and b are equal in terms of sorting
    })
</script>

<Banner id="bottom-banner" position="relative">
  <p
    class="flex items-center text-sm font-normal text-gray-500 dark:text-gray-400"
  >
    <span
      class="inline-flex p-1 mr-3 bg-gray-200 rounded-full dark:bg-gray-600"
    >
      <svg
        class="w-4 h-4 text-gray-500 dark:text-gray-400"
        fill="currentColor"
        viewBox="0 0 20 20"
        xmlns="http://www.w3.org/2000/svg"
        aria-hidden="true"
      >
        <path
          d="M11 3a1 1 0 10-2 0v1a1 1 0 102 0V3zM15.657 5.757a1 1 0 00-1.414-1.414l-.707.707a1 1 0 001.414 1.414l.707-.707zM18 10a1 1 0 01-1 1h-1a1 1 0 110-2h1a1 1 0 011 1zM5.05 6.464A1 1 0 106.464 5.05l-.707-.707a1 1 0 00-1.414 1.414l.707.707zM5 10a1 1 0 01-1 1H3a1 1 0 110-2h1a1 1 0 011 1zM8 16v-1h4v1a2 2 0 11-4 0zM12 14c.015-.34.208-.646.477-.859a4 4 0 10-4.954 0c.27.213.462.519.476.859h4.002z"
        />
      </svg>
      <span class="sr-only">Issues and Comments</span>
    </span>
    <span
      >This project is open source. Please report issues and comments on our <a
        href="https://github.com/fawadasaurus/d4-aspect-tracker/issues"
        class="inline font-medium text-primary-600 underline dark:text-primary-500 underline-offset-2 decoration-600 dark:decoration-500 decoration-solid hover:no-underline"
        >Github</a
      ></span
    >
  </p>
</Banner>

<div class="p-4">
  <div class="mb-8 md:max-w-md mx-auto">
    <h1 class="text-2xl text-red-600 font-medium mb-4">D4 Aspect Tracker</h1>
    <Input
      bind:value={searchTerm}
      placeholder="Search by name or description"
      class="mt-2"
    />
    <Select
      placeholder="Select a class"
      class="mt-2"
      items={classes}
      bind:value={selectedClass}
    />
    <Select
      placeholder="Select item slot"
      class="mt-2"
      items={slots}
      bind:value={selectedSlot}
    />
    <Select
      placeholder="Both In Codex and Not in Codex"
      class="mt-2"
      items={codex}
      bind:value={selectedCodex}
    />
    <div class="mt-2">
      <Checkbox class="text-base" bind:checked={limitToOwned}>
        Limit to owned</Checkbox
      >
    </div>
  </div>

  <div
    class="grid grid-cols-1 gap-4 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4"
  >
    {#if aspects.length > 0}
      {#each filteredAspects as aspect}
        <Aspect {aspect} on:aspectUpdated={handleAspectUpdated} />
      {/each}
    {:else}
      <Spinner />
    {/if}
  </div>
</div>
