<template>
  <component :is="type" v-bind="linkProps()" @click="handleClick">
    <slot />
  </component>
</template>

<script setup>
import { isExternal } from '@/utils/validate'

const props = defineProps({
  to: {
    type: [String, Object],
    required: true
  }
})

const route = useRoute()
const router = useRouter()

const isExt = computed(() => {
  return isExternal(props.to)
})

const type = computed(() => {
  if (isExt.value) {
    return 'a'
  }
  return 'router-link'
})

function linkProps() {
  if (isExt.value) {
    return {
      href: props.to,
      target: '_blank',
      rel: 'noopener'
    }
  }
  return {
    to: props.to
  }
}

function handleClick(e) {
  if (isExt.value) return

  const targetPath = typeof props.to === 'string' ? props.to : props.to.path
  const currentPath = route.path

  if (targetPath === currentPath) {
    e.preventDefault()
    router.replace({
      path: '/redirect' + currentPath,
      query: route.query
    })
  }
}
</script>
