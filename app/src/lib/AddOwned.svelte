<script lang="ts">
  import { Card, Button, Input, Select } from 'flowbite-svelte'
  import { createEventDispatcher } from 'svelte'
  import type { OwnedAspect } from './types'

  export let aspectName = ''
  export let ownedAspects: OwnedAspect[] = []

  let aspectValue = ''
  let selectedSlot = ''

  let slots = [
    { value: '', name: 'Extracted' },
    { value: 'Helmet', name: 'Helmet' },
    { value: 'Chest', name: 'Chest' },
    { value: 'Gloves', name: 'Gloves' },
    { value: 'Pants', name: 'Pants' },
    { value: 'Boots', name: 'Boots' },
    { value: 'Weapon', name: 'Weapon' },
    { value: '2H-Weapon', name: '2H Weapon' },
    { value: 'Amulet', name: 'Amulet' },
    { value: 'Ring', name: 'Ring' },
    { value: 'Offhand', name: 'Offhand' },
  ]

  const dispatch = createEventDispatcher()

  function roundDecimals(number) {
    if (Number.isInteger(number)) {
      return number.toString() // Return non-decimal value without decimal places
    } else {
      return number.toFixed(2) // Round decimal value to 2 decimal places
    }
  }

  function addOwnedAspect() {
    const divider =
      selectedSlot === 'Amulet' ? 1.5 : selectedSlot === '2H-Weapon' ? 2 : 1
    const actualAspectValue = roundDecimals(
      Math.abs(Number(aspectValue)) / divider
    )
    let shownValue = ''
    if (actualAspectValue != aspectValue) {
      shownValue = ' (' + aspectValue + ')'
    }
    const ownedAspect: OwnedAspect = {
      note: actualAspectValue + ', ' + selectedSlot + shownValue,
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

<Card class="p-2 md:p-4">
  <h3 class="text-sm md:text-base">Add Owned Aspect</h3>
  <div class="flex items-center">
    <Input
      type="number"
      min="0"
      inputmode="numeric"
      bind:value={aspectValue}
      placeholder="Enter value"
      class="text-xs md:text-base mr-2"
    />
    <Select
      placeholder="Select slot"
      class="mt-2"
      items={slots}
      bind:value={selectedSlot}
    />
    <Button on:click={addOwnedAspect} class="text-xs md:text-base py-1 px-2"
      >Add</Button
    >
  </div>
</Card>
