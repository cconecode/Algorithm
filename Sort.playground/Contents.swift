import UIKit

class Sort {
    
    // 插入排序
    func insertionSort(_ lists: [Int]) -> [Int] {
        var numbers = lists
        for i in 1..<numbers.count {
            for j in (1...i).reversed() {
                if numbers[j] < numbers[j-1] {
                    let temp = numbers[j]
                    numbers[j] = numbers[j-1]
                    numbers[j-1] = temp
                }
            }
        }
        return numbers
    }
    
    // 选择排序
    func selectionSort(lists: [Int]) -> [Int] {
        var numbes = lists
        for i in 0 ..< numbes.count {
            var min = numbes[i]
            var index = i
            for j in i + 1 ..< numbes.count {
                if numbes[j] < min {
                    min = numbes[j]
                    index = j
                }
            }
            let temp = numbes[i]
            numbes[i] = numbes[index]
            numbes[index] = temp
        }
        return numbes
    }
    
    // 归并排序
    func mergesort(nums: [Int]) -> [Int] {
        
        if nums.count <= 1 {
            return nums
        }
        let m = nums.count / 2
        let left = Array(nums[0...m-1])
        let right = Array(nums[m...nums.count-1])
        // 递归的将数组分割
        var subLeft = mergesort(nums: left)
        var subRight = mergesort(nums: right)
        // 合并
        let result = merge(left: &subLeft, right: &subRight)
        return result
    }

    func merge(left: inout [Int], right: inout [Int]) -> [Int] {
        var result:[Int] = []
        while !left.isEmpty && !right.isEmpty {
            // 左右子数组比较，谁小取谁
            if left[0] < right[0] {
                result.append(left[0])
                left.remove(at: 0)
            }else {
                result.append(right[0])
                right.remove(at: 0)
            }
            // 其中一个子数组取完了，则直接将另一个子数组拼接在数组后面
            if left.isEmpty {
                result += right
            }else if right.isEmpty {
                result += left
            }
        }
        return result
    }
    
    // 快排
    func quickSort(nums: inout [Int], start: Int, end: Int) {
        if nums.count <= 1 || start >= end {
            return
        }
        // 以第一个元素为基准值
        let pivot = nums[start]
        var head = start + 1
        var tail = end
        while head != tail {
            // 从右向前寻找，找到一个小于基准值的数
            while nums[tail] > pivot && head < tail {
                tail -= 1
            }

            // 从左向后找，找到一个大于基准值的数
            while nums[head] < pivot && head < tail {
                head += 1
            }
            // 交换上面找到的两个数
            if head < tail {
                nums.swapAt(head, tail)
            }
        }
        // 将最后的索引与基准值索引交换一下，最后的索引就是基准值的最终确定位置
        nums.swapAt(start, head)
        // 将数组分成基于基准值索引的左右两部分，递归的进行排序
        quickSort(nums: &nums, start: start, end: head - 1)
        quickSort(nums: &nums, start: head + 1, end: end)
    }
}

// 堆排序
struct Heap<Element> {
    var elements: [Element]
    let priorityFunction: (Element, Element) -> Bool
    var count: Int {
        return elements.count
    }
    
    init(elements: [Element] = [], priorityFunction: @escaping (Element, Element) -> Bool) {
        self.elements = elements
        self.priorityFunction = priorityFunction
        constructHeap()
    }
    
    mutating func constructHeap() {
        for index in (0 ..< count / 2).reversed() {
            siftDown(elementAtIndex: index)
        }
    }
    
    mutating func siftDown(elementAtIndex index: Int) {
        let childIndex = highestPriorityIndex(for: index)
        if index == childIndex {
            return
        }
        swapElement(at: index, with: childIndex)
        siftDown(elementAtIndex: childIndex)
    }
    
    mutating func siftUp(elementAtIndex index: Int) {
        let parent = parentIndex(of: index)
        guard !isRoot(index), isHigherPriority(at: index, than: parent) else {
            return
        }
        swapElement(at: index, with: parent)
        siftUp(elementAtIndex: parent)
    }
    
    // 父节点先与左子节点对比，再将结果与右子节点对比
    func highestPriorityIndex(for parent: Int) -> Int {
        return highestPriorityIndex(of: highestPriorityIndex(of: parent, and: leftChild(of: parent)), and: rightChild(of: parent))
    }
    
    // 父节点与子节点的大小比对
    func highestPriorityIndex(of parentIndex: Int, and childIndex: Int) -> Int {
        guard childIndex < count && isHigherPriority(at: childIndex, than: parentIndex) else {
            return parentIndex
        }
        return childIndex
    }
    
    // 两个节点是否满足堆性质
    func isHigherPriority(at firstIndex: Int, than secondIndex: Int) -> Bool {
        return priorityFunction(elements[firstIndex], elements[secondIndex])
    }
    
    // 交换两个元素
    mutating func swapElement(at firstIndex: Int, with secondIndex: Int) {
        guard firstIndex != secondIndex else {
            return
        }
        elements.swapAt(firstIndex, secondIndex)
    }
    
    func isRoot(_ index: Int) -> Bool {
        return index == 0
    }
    
    func leftChild(of index: Int) -> Int {
        return 2 * index + 1
    }
    
    func rightChild(of index: Int) -> Int {
        return 2 * index + 2
    }
    
    func parentIndex(of index: Int) -> Int {
        return (index - 1) / 2
    }
}

