<script lang="ts">
  import AddOwned from './AddOwned.svelte'
  import ListOwned from './ListOwned.svelte'
  import { createEventDispatcher } from 'svelte'

  const dispatch = createEventDispatcher()

  export let aspect
  export let selectedLocalization

  function formatText(text) {
    const regex = /([x+]?){([^}]+)}(%?)/g
    const matches = text.matchAll(regex)

    let replace = text

    for (const match of matches) {
      const [keyword, x, range, percent] = match
      const stats = `<span class="text-blue-500 whitespace-nowrap">${x}[${range?.replace(
        '/',
        '-'
      )}]${percent}</span>`
      replace = replace.replace(keyword, stats)
    }

    return replace
  }

  function handleAspectUpdated() {
    ownedAspects = JSON.parse(localStorage.getItem(aspect.name)) || []
    dispatch('aspectUpdated')
  }

  function standardize(name) {
    //check the first character of the name.  if it is a [
    //then it is a localized name and we need to remove the [ and ]
    if (name[0] === '[') {
      return name.split(']')[1].split('[')[0]
    } else {
      return name
    }
  }

  $: ownedAspects = JSON.parse(localStorage.getItem(aspect.name)) || []
</script>

<div class="mb-8 flex flex-col">
  <h3 class="text-lg font-medium mb-2 text-amber-600">
    {standardize(aspect.name_localized[selectedLocalization])}, {aspect.category}
    {aspect.in_codex ? '(Codex)' : ''}
  </h3>
  <p class="text-base mb-4 flex-grow">
    {@html formatText(aspect.desc_localized[selectedLocalization])}
  </p>

  {#if ownedAspects.length > 0}
    <ListOwned
      aspectName={aspect.name}
      {ownedAspects}
      on:aspectUpdated={handleAspectUpdated}
    />
  {/if}
  <AddOwned
    aspectName={aspect.name}
    aspectCategory={aspect.category}
    {ownedAspects}
    on:aspectUpdated={handleAspectUpdated}
  />
</div>
