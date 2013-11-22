define (require) ->
	(el) ->
		# Native alternative to $.closest
		# See http://stackoverflow.com/questions/15329167/closest-ancestor-matching-selector-using-native-dom
		closest: (selector) ->
			matchesSelector = el.matches or el.webkitMatchesSelector or el.mozMatchesSelector or el.msMatchesSelector

			while (el)
				if (matchesSelector.bind(el)(selector)) then return el else	el = el.parentNode

		prepend: (childEl) ->
			el.insertBefore childEl, el.firstChild

		###
		Native alternative to jQuery's $.offset()

		http://www.quirksmode.org/js/findpos.html
		###
		position: (parent=document.body) ->
			left = 0
			top = 0
			loopEl = el

			while loopEl isnt parent
				# Not every parent is an offsetParent. So in the case the user has passed a non offsetParent as the parent, 
				# we check if we have passed the parent (by checking if the offsetParent has a descendant which is the parent).
				break if @hasDescendant parent

				left += loopEl.offsetLeft
				top += loopEl.offsetTop

				loopEl = loopEl.offsetParent

			left: left
			top: top

		###
		Is child el a descendant of parent el?

		http://stackoverflow.com/questions/2234979/how-to-check-in-javascript-if-one-element-is-a-child-of-another
		###
		hasDescendant: (child) ->
			node = child.parentNode
			
			while node?
				return true if node is el
				node = node.parentNode

			return false

		boundingBox: ->
			box = @position()
			box.width = el.clientWidth
			box.height = el.clientHeight
			box.right = box.left + box.width
			box.bottom = box.top + box.height

			box

		insertAfter: (newElement, referenceElement) -> referenceElement.parentNode.insertBefore newElement, referenceElement.nextSibling


		# Example usage:
		# highlighter = null # Create a reference highlighter
		# @$("div.hover")
		# 	.mouseenter (ev) =>
		# 		startNode = @el.querySelector "span.start_node']"
		# 		endNode = @el.querySelector "span.end_node']"
		# 		highlighter = dom(startNode).highlightUntil(endNode).on()
		# 	.mouseleave (ev) =>
		# 		highlighter.off()
		highlightUntil: (endNode, highlightClass='highlight') ->
			on: ->
				range = document.createRange()
				range.setStartAfter el
				range.setEndBefore endNode

				filter = (node) => 
					r = document.createRange()
					r.selectNode(node)

					start = r.compareBoundaryPoints(Range.START_TO_START, range)
					end = r.compareBoundaryPoints(Range.END_TO_START, range)

					if start is -1 or end is 1 then NodeFilter.FILTER_SKIP else	NodeFilter.FILTER_ACCEPT

				filter.acceptNode = filter
				
				treewalker = document.createTreeWalker range.commonAncestorContainer, NodeFilter.SHOW_ELEMENT, filter, false
				
				while treewalker.nextNode()
					currentNode = treewalker.currentNode

					currentNode.className = currentNode.className + ' ' + highlightClass if (' ' + currentNode.className + ' ').indexOf(' text ') > -1

				@

			off: ->
				for el in document.querySelectorAll('.' + highlightClass)
					classNames = ' ' + el.className + ' '
					classNames = classNames.replace ' ' + highlightClass + ' ', ''
					el.className = classNames.replace /^\s+|\s+$/g, ''