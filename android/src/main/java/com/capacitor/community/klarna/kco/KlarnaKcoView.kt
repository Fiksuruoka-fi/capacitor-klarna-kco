package com.capacitor.community.klarna.kco

import android.app.Dialog
import android.content.DialogInterface
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.getcapacitor.JSObject
import com.getcapacitor.Logger
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.google.android.material.bottomsheet.BottomSheetDialog
import com.google.android.material.bottomsheet.BottomSheetDialogFragment
import com.klarna.mobile.sdk.api.checkout.KlarnaCheckoutView


open class RoundedBottomSheetDialogFragment() : BottomSheetDialogFragment() {
    override fun getTheme(): Int = R.style.BottomSheetDialogTheme
    override fun onCreateDialog(savedInstanceState: Bundle?): Dialog = BottomSheetDialog(requireContext(), theme)
}

class KlarnaKcoView(private val kco: KlarnaKco, private val kcoView: KlarnaCheckoutView): RoundedBottomSheetDialogFragment() {
    private var kcoViewAdded = false
    private lateinit var contentView: ViewGroup

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        super.onCreateView(inflater, container, savedInstanceState)
        val view = inflater.inflate(R.layout.modal_bottom_sheet_content, container, false)
        contentView = view.findViewById(R.id.checkoutContainer)
        return view
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        contentView.addView(kcoView)
        kcoViewAdded = true
    }

    override fun onStart() {
        val behavior = (this.dialog as BottomSheetDialog).behavior
        val maxHeight = (resources.displayMetrics.heightPixels * 0.9f).toInt()
        behavior.peekHeight = maxHeight
        behavior.maxHeight = maxHeight

        val bottomSheetCallback = object : BottomSheetBehavior.BottomSheetCallback() {
            override fun onStateChanged(bottomSheet: View, newState: Int) {
                when (newState) {
                    BottomSheetBehavior.STATE_EXPANDED -> {
                        behavior.state = BottomSheetBehavior.STATE_COLLAPSED
                    }
                    BottomSheetBehavior.STATE_HALF_EXPANDED -> {
                        behavior.state = BottomSheetBehavior.STATE_COLLAPSED
                    }
                    BottomSheetBehavior.STATE_COLLAPSED -> {
                        kco.opened = true
                        kco.notifyWeb("opened", JSObject())
                    }
                    BottomSheetBehavior.STATE_HIDDEN -> {
                        // removeCheckoutView()
                        kco.opened = false
                        kco.notifyWeb("closed", JSObject())
                    }
                }
            }

            override fun onSlide(bottomSheet: View, slideOffset: Float) {}
        }

        behavior.state = BottomSheetBehavior.STATE_COLLAPSED
        behavior.addBottomSheetCallback(bottomSheetCallback)

        super.onStart()
    }

    override fun onCancel(dialog: DialogInterface) {
        super.onCancel(dialog)
        Logger.info("Klarna KCO plugin: Cancel the bottom sheet dialog")
        removeCheckoutView()
        kco.opened = false
        kco.notifyWeb("closed", JSObject())
    }

    fun removeCheckoutView() {
        val checkoutContainer = view?.findViewById<ViewGroup>(R.id.checkoutContainer)
        checkoutContainer?.removeView(kcoView)
    }

    companion object {
        const val TAG = "ModalBottomSheet"
    }
}
