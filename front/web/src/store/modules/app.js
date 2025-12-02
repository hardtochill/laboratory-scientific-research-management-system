import Cookies from 'js-cookie'

const useAppStore = defineStore(
    'app',
    {
        state: () => ({
            sidebar: {
                opened: Cookies.get('sidebarStatus') ? !!+Cookies.get('sidebarStatus') : true,
                withoutAnimation: false,
                hide: false
            },
            device: 'desktop',
            hiddenLayout: false,  // 新增，控制是否显示头部/侧边栏
            size: Cookies.get('size') || 'default'
        }),
        actions: {
            toggleSideBar(withoutAnimation) {
                if (this.sidebar.hide) {
                    return false
                }
                this.sidebar.opened = !this.sidebar.opened
                this.sidebar.withoutAnimation = withoutAnimation
                if (this.sidebar.opened) {
                    Cookies.set('sidebarStatus', 1)
                } else {
                    Cookies.set('sidebarStatus', 0)
                }
            },
            closeSideBar({withoutAnimation}) {
                Cookies.set('sidebarStatus', 0)
                this.sidebar.opened = false
                this.sidebar.withoutAnimation = withoutAnimation
            },
            toggleDevice(device) {
                this.device = device
            },
            setSize(size) {
                this.size = size
                Cookies.set('size', size)
            },
            toggleSideBarHide(status) {
                this.sidebar.hide = status
            },
            toggleLayoutHidden(status) {
                this.hiddenLayout = status
            }
        }
    })

export default useAppStore
