<script lang="ts">
  import { Button, Input, Select } from 'flowbite-svelte'
  import { createEventDispatcher } from 'svelte'
  import type { OwnedAspect } from './types'

  export let aspectName
  export let aspectCategory
  export let ownedAspects: OwnedAspect[] = []

  let aspectValue = ''
  let selectedSlot = ''
  let aspectSecondValue = ''
  let noteValue = ''

  // "Defensive": "Amulet [+50%], Chest, Helmet, Pants, Shield.",
  // 	"Offensive": "Amulet [+50%], Gloves, Ring, 1H Weapon, 2H Weapon [+100%].",
  // 	"Utility": "Amulet [+50%], Boots, Chest, Gloves, Helmet, Shield.",
  // 	"Resource": "Ring.",
  // 	"Mobility": "Amulet [+50%], Boots.",
  //  "Weapon": "1H Weapon, 2H Weapon [+100%].",

  let doubleEntryAspects = [
    'of Ultimate Shadow',
    'Earthquake',
    'of Bul-Kathos',
    'of Cruel Sustenance',
    'of Shattered Stars',
    'of Ultimate Shadow',
    'Overcharged',
    'Snap Frozen',
    "Runeworker's Conduit",
    'of Piercing Cold',
  ]

  let inverseAspects = [
    'Seismic-shift',
    'Blood-bathed',
    'Eluding',
    'Frostblitz',
    'Gravitational',
    "Infiltrator's",
    'of Piercing Cold',
    'Serpentine',
    'Tidal',
  ]

  let aspectSlots = {
    Defensive: [
      { value: '', name: 'Extracted' },
      { value: 'Amulet', name: 'Amulet' },
      { value: 'Chest', name: 'Chest' },
      { value: 'Helmet', name: 'Helmet' },
      { value: 'Pants', name: 'Pants' },
      { value: 'Shield', name: 'Shield' },
    ],
    Offensive: [
      { value: '', name: 'Extracted' },
      { value: 'Amulet', name: 'Amulet' },
      { value: 'Gloves', name: 'Gloves' },
      { value: 'Ring', name: 'Ring' },
      { value: '1H-Weapon', name: '1H-Weapon' },
      { value: 'Offhand', name: 'Offhand' },
      { value: '2H-Weapon', name: '2H-Weapon' },
    ],
    Utility: [
      { value: '', name: 'Extracted' },
      { value: 'Amulet', name: 'Amulet' },
      { value: 'Boots', name: 'Boots' },
      { value: 'Chest', name: 'Chest' },
      { value: 'Gloves', name: 'Gloves' },
      { value: 'Helmet', name: 'Helmet' },
      { value: 'Shield', name: 'Shield' },
    ],
    Resource: [
      { value: '', name: 'Extracted' },
      { value: 'Ring', name: 'Ring' },
    ],
    Mobility: [
      { value: '', name: 'Extracted' },
      { value: 'Amulet', name: 'Amulet' },
      { value: 'Boots', name: 'Boots' },
    ],
    Weapon: [
      { value: '', name: 'Extracted' },
      { value: '1H-Weapon', name: '1H Weapon' },
      { value: '2H-Weapon', name: '2H Weapon' },
    ],
  }

  const dispatch = createEventDispatcher()

  function roundDecimals(number) {
    if (Number.isInteger(number)) {
      return number.toFixed(0)
    }
    if (number < 1) {
      return number.toFixed(2)
    }
    if (number < 5) {
      return number.toFixed(1)
    }

    return number.toFixed(0)
  }

  function addOwnedAspect() {
    if (Number(aspectValue) === 0) return

    let divider1 =
      selectedSlot === 'Amulet' ? 1.5 : selectedSlot === '2H-Weapon' ? 2 : 1
    let divider2 =
      selectedSlot === 'Amulet' ? 1.5 : selectedSlot === '2H-Weapon' ? 2 : 1

    if (inverseAspects.includes(aspectName)) {
      if (aspectName != 'of Piercing Cold') {
        divider1 = 1 / divider1
      }
      divider2 = 1 / divider2
    }

    const actualAspectValue = roundDecimals(
      Math.abs(Number(aspectValue)) / divider1
    )

    let actualSecondValue = ''

    if (aspectSecondValue != '') {
      actualSecondValue = roundDecimals(
        Math.abs(Number(aspectSecondValue)) / divider2
      )
      actualSecondValue = '/' + actualSecondValue
    }

    let shownValue = ''
    if (actualAspectValue != aspectValue) {
      shownValue = ': (' + aspectValue + ')'
    }

    let shownSecondValue = ''
    if (actualSecondValue != aspectSecondValue) {
      shownSecondValue = '/(' + aspectSecondValue + ')'
    }

    const ownedAspect: OwnedAspect = {
      note: `${actualAspectValue}${actualSecondValue}${
        selectedSlot ? ', ' : ''
      }${selectedSlot}${shownValue}${shownSecondValue}`,
      time: new Date().toLocaleString(),
      note_long: noteValue,
    }

    const ownedAspectData = localStorage.getItem(aspectName)
    if (ownedAspectData) {
      ownedAspects = JSON.parse(ownedAspectData)
    }
    ownedAspects.push(ownedAspect)

    localStorage.setItem(aspectName, JSON.stringify(ownedAspects))
    dispatch('aspectUpdated')
    aspectValue = ''
    aspectSecondValue = ''
    selectedSlot = ''
    noteValue = ''
    gtag('event', 'Add Aspect', {
      event_name: 'add_aspect',
    })
  }
</script>

<div
  class="mt-2 grid {doubleEntryAspects.includes(aspectName)
    ? 'grid grid-cols-3'
    : 'grid grid-cols-2'} gap-2"
>
  <Input
    type="number"
    min="0"
    inputmode="decimal"
    bind:value={aspectValue}
    placeholder="Enter value"
    class="mr-2"
  />
  {#if doubleEntryAspects.includes(aspectName)}
    <Input
      type="number"
      min="0"
      inputmode="decimal"
      bind:value={aspectSecondValue}
      placeholder="Enter value"
      class="mr-2"
    />
  {/if}
  <Select
    class="mr-2"
    items={aspectSlots[aspectCategory] || []}
    bind:value={selectedSlot}
  />
</div>
<div class="mt-2 grid grid-cols-2 gap-2">
  <Input class="mr-10" bind:value={noteValue} placeholder="Enter notes" />
  <Button on:click={addOwnedAspect} color="yellow" outline>Add</Button>
</div>
