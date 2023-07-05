<script lang="ts">
  import { Card, Button, Input, Select } from 'flowbite-svelte'
  import { createEventDispatcher } from 'svelte'
  import type { OwnedAspect } from './types'

  export let aspectName
  export let aspectCategory
  export let ownedAspects: OwnedAspect[] = []

  let aspectValue = ''
  let selectedSlot = ''

  // "Defensive": "Amulet [+50%], Chest, Helmet, Pants, Shield.",
  // 	"Offensive": "Amulet [+50%], Gloves, Ring, 1H Weapon, 2H Weapon [+100%].",
  // 	"Utility": "Amulet [+50%], Boots, Chest, Gloves, Helmet, Shield.",
  // 	"Resource": "Ring.",
  // 	"Mobility": "Amulet [+50%], Boots.",

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
      { value: '1H Weapon', name: '1H Weapon' },
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
  }

  const dispatch = createEventDispatcher()

  function roundDecimals(number) {
    if (Number.isInteger(number)) {
      return number.toString() // Return non-decimal value without decimal places
    } else if (number < 1) {
      return number.toFixed(2) // Round decimal value to 4 decimal places
    } else if (number < 5) {
      return number.toFixed(1) // Round decimal value to 2 decimal places
    }
  }

  function addOwnedAspect() {
    if (Number(aspectValue) === 0) return

    const divider =
      selectedSlot === 'Amulet' ? 1.5 : selectedSlot === '2H-Weapon' ? 2 : 1
    const actualAspectValue = roundDecimals(
      Math.abs(Number(aspectValue)) / divider
    )
    let shownValue = ''
    if (actualAspectValue != aspectValue) {
      shownValue = '(' + aspectValue + ')'
    }
    const ownedAspect: OwnedAspect = {
      note: `${actualAspectValue}${
        selectedSlot ? ', ' : ''
      }${selectedSlot} ${shownValue}`,
      time: new Date().toLocaleString(),
    }

    const ownedAspectData = localStorage.getItem(aspectName)
    if (ownedAspectData) {
      ownedAspects = JSON.parse(ownedAspectData)
    }
    ownedAspects.push(ownedAspect)

    localStorage.setItem(aspectName, JSON.stringify(ownedAspects))
    dispatch('aspectUpdated')
    aspectValue = ''
  }
</script>

<div>
  <div class="flex">
    <Input
      type="number"
      min="0"
      inputmode="numeric"
      bind:value={aspectValue}
      placeholder="Enter value"
      class="mr-2"
    />
    <Select
      class="mr-2"
      items={aspectSlots[aspectCategory] || []}
      bind:value={selectedSlot}
    />
    <Button on:click={addOwnedAspect} color="yellow" outline>Add</Button>
  </div>
</div>
