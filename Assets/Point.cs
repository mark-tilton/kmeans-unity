using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Point : MonoBehaviour
{
    public int Class = 0;

    private bool _isBeingDragged;
    private SpriteRenderer _renderer;

    private IReadOnlyList<Color> _classes = new List<Color>
    {
        Color.red,
        Color.blue,
        Color.yellow,
    };

    // Start is called before the first frame update
    void Start()
    {
        _renderer = transform.GetComponent<SpriteRenderer>();
    }

    // Update is called once per frame
    void Update()
    {
        _renderer.color = _classes[Class];

        var mousePosition = Camera.main.ScreenToWorldPoint(new Vector3(Input.mousePosition.x, Input.mousePosition.y, 10));

        // Stop dragging if left click is up.
        if(Input.GetMouseButtonUp(0))
        {
            _isBeingDragged = false;
        }

        if((mousePosition - transform.position).magnitude < 0.15 || _isBeingDragged)
        {
            _renderer.color = Color.green;
            if(Input.GetMouseButtonDown(0))
            {
                _isBeingDragged = true;
            }
            if(Input.GetMouseButtonDown(1))
            {
                Class = (Class + 1) % _classes.Count;
            }
        }

        if(_isBeingDragged)
        {
            transform.SetPositionAndRotation(mousePosition, Quaternion.identity);
        }
    }
}
